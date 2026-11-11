# Online connection, always running (autoload "Net").
# Two players meet in a "room" named by a short join code. Everything one
# player sends, the other receives, through Supabase Realtime (a free online
# message service). No server of our own: the host's game is in charge.
#
# Other scripts use it like this:
#   Net.host_game()            make a new room and wait for a friend
#   Net.join_game("K7QM")      join a friend's room
#   Net.send("hello", {...})   send a message to the other player
#   Net.message_received       signal: (event, data) from the other player
#   Net.leave()                close the connection
extends Node

## Supabase project address, e.g. "https://abcdefgh.supabase.co".
## Found in the Supabase dashboard: Project Settings > API.
const SUPABASE_URL := "https://lcqtjcsnrauzacierbqt.supabase.co"
## Supabase "publishable" (or "anon") key. It is meant to be public:
## it ships inside the web game anyway and only allows what the game needs.
const SUPABASE_KEY := "sb_publishable_a7wPGI1qXbz8cd0LjZKAKA_TWbBlluk"

## Prefix for room names, so other uses of the Supabase project never mix in.
const ROOM_PREFIX := "squares-"
## Letters used in join codes. No 0/O or 1/I, so codes are easy to read aloud.
const CODE_LETTERS := "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
const CODE_LENGTH := 4

signal room_joined                          # we are in the room, ready to talk
signal message_received(event: String, data: Dictionary)
signal connection_failed(reason: String)    # could not connect, or connection lost

enum State { OFFLINE, CONNECTING, JOINING, IN_ROOM }

var state := State.OFFLINE
var room_code := ""
var is_host := false
## A random id for this game window, so we can tell players apart.
var my_id := ""
## Filled in by the lobby, read by the multiplayer game.
var my_name := ""
var other_name := ""
## The code a player typed (or got from a link) before the lobby opens.
var wanted_code := ""

var _socket := WebSocketPeer.new()
var _ref := 0
var _join_ref := ""
var _heartbeat_left := 0.0


func is_configured() -> bool:
	return SUPABASE_URL != "" and SUPABASE_KEY != ""


func new_code() -> String:
	var code := ""
	for i in CODE_LENGTH:
		code += CODE_LETTERS[randi_range(0, CODE_LETTERS.length() - 1)]
	return code


## Cleans up what a player typed: capitals only, no spaces.
func clean_code(text: String) -> String:
	return text.strip_edges().to_upper().replace(" ", "")


func host_game() -> void:
	is_host = true
	_open(new_code())


func join_game(code: String) -> void:
	is_host = false
	_open(clean_code(code))


func send(event: String, data: Dictionary = {}) -> void:
	if state != State.IN_ROOM:
		return
	data["from"] = my_id
	_push("broadcast", {"type": "broadcast", "event": event, "payload": data})


func leave() -> void:
	if state == State.IN_ROOM:
		send("bye")
		_push("phx_leave", {})
	if state != State.OFFLINE:
		_socket.close()
	state = State.OFFLINE
	room_code = ""
	other_name = ""


## Link that opens the web game straight into this room (web build only).
func invite_link() -> String:
	if not OS.has_feature("web"):
		return ""
	var page := str(JavaScriptBridge.eval("window.location.origin + window.location.pathname"))
	return page + "?join=" + room_code


## Join code from the web page address (?join=K7QM), or "" if there is none.
func code_from_page_address() -> String:
	if not OS.has_feature("web"):
		return ""
	var code = JavaScriptBridge.eval("new URLSearchParams(window.location.search).get('join') || ''")
	return clean_code(str(code))


## Removes ?join=... from the address, so a page reload doesn't re-join.
func clear_page_address() -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("history.replaceState(null, '', window.location.pathname)")


func _ready() -> void:
	randomize()
	my_id = str(randi()) + str(Time.get_ticks_usec())


func _open(code: String) -> void:
	leave()
	if not is_configured():
		connection_failed.emit("Online play isn't set up yet.")
		return
	room_code = code
	_socket = WebSocketPeer.new()
	_join_ref = ""
	_heartbeat_left = 25.0
	var host := SUPABASE_URL.replace("https://", "wss://").replace("http://", "ws://")
	var url := host + "/realtime/v1/websocket?apikey=" + SUPABASE_KEY.uri_encode() + "&vsn=1.0.0"
	var err := _socket.connect_to_url(url)
	if err != OK:
		connection_failed.emit("Could not reach the online service.")
		return
	state = State.CONNECTING


func _process(delta: float) -> void:
	if state == State.OFFLINE:
		return
	_socket.poll()
	var socket_state := _socket.get_ready_state()

	if socket_state == WebSocketPeer.STATE_CLOSED:
		state = State.OFFLINE
		connection_failed.emit("Lost the connection to the online service.")
		return

	if socket_state != WebSocketPeer.STATE_OPEN:
		return

	if state == State.CONNECTING:
		_join_room()

	while _socket.get_available_packet_count() > 0:
		_handle(_socket.get_packet().get_string_from_utf8())

	# The service drops quiet connections, so say "still here" regularly.
	_heartbeat_left -= delta
	if _heartbeat_left <= 0.0:
		_heartbeat_left = 25.0
		_push("heartbeat", {}, "phoenix")


func _join_room() -> void:
	state = State.JOINING
	_ref += 1
	_join_ref = str(_ref)
	var config := {
		"broadcast": {"self": false, "ack": false},
		"presence": {"key": ""},
		"private": false,
	}
	_send_raw({
		"topic": _topic(),
		"event": "phx_join",
		"payload": {"config": config},
		"ref": _join_ref,
		"join_ref": _join_ref,
	})


func _handle(text: String) -> void:
	var msg = JSON.parse_string(text)
	if typeof(msg) != TYPE_DICTIONARY:
		return
	var event: String = msg.get("event", "")
	var payload = msg.get("payload", {})
	if typeof(payload) != TYPE_DICTIONARY:
		payload = {}

	if event == "phx_reply" and str(msg.get("ref", "")) == _join_ref and state == State.JOINING:
		if payload.get("status", "") == "ok":
			state = State.IN_ROOM
			room_joined.emit()
		else:
			push_warning("Net: join refused: " + text)
			leave()
			connection_failed.emit("The online service refused the room.")
	elif event == "broadcast":
		var data = payload.get("payload", {})
		if typeof(data) == TYPE_DICTIONARY and data.get("from", "") != my_id:
			message_received.emit(str(payload.get("event", "")), data)
	elif event == "phx_error" or event == "phx_close":
		if state != State.OFFLINE and msg.get("topic", "") == _topic():
			leave()
			connection_failed.emit("Lost the connection to the room.")


func _topic() -> String:
	return "realtime:" + ROOM_PREFIX + room_code


func _push(event: String, payload: Dictionary, topic := "") -> void:
	_ref += 1
	_send_raw({
		"topic": topic if topic != "" else _topic(),
		"event": event,
		"payload": payload,
		"ref": str(_ref),
		"join_ref": _join_ref,
	})


func _send_raw(msg: Dictionary) -> void:
	if _socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		_socket.send_text(JSON.stringify(msg))
