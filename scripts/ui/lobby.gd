# Lobby: where two players meet before a multiplayer game.
# The host is on the left, the guest on the right. Each types a name and
# presses Ready. When both are ready, the host starts a 3-2-1 countdown on
# both screens, and then the multiplayer game begins.
#
# Messages between the two lobbies (sent with Net.send):
#   "hello"  {role, name, ready}  who I am; sent on joining and on every change
#   "full"   {to}                 host to a third player: this game is taken
#   "ping"   {}                   "still here", every second
#   "start"  {}                   host: both are ready, count down now
#   "bye"    {}                   sent automatically when a player leaves
extends Control

## Seconds to wait for the host to answer before saying the code is wrong.
@export var join_timeout := 6.0
## Seconds without any message before we decide the other player has gone.
@export var other_player_timeout := 5.0
## Seconds between "still here" messages.
@export var ping_interval := 1.0
## Name used for the host when they don't type one.
@export var host_default_name := "Player1"
## Name used for the guest when they don't type one.
@export var guest_default_name := "Player2"
## Numbers shown in the countdown, one per second.
@export var countdown_from := 3

var my_ready := false
var other_id := ""
var other_ready := false
var counting_down := false

var _my_name_edit: LineEdit
var _other_name_edit: LineEdit
var _my_ready_label: Label
var _other_ready_label: Label
var _time_since_heard := 0.0
var _time_to_ping := 0.0
var _time_waiting_for_host := 0.0


func _ready() -> void:
	if Net.is_host:
		_my_name_edit = %HostName
		_other_name_edit = %GuestName
		_my_ready_label = %HostReady
		_other_ready_label = %GuestReady
	else:
		_my_name_edit = %GuestName
		_other_name_edit = %HostName
		_my_ready_label = %GuestReady
		_other_ready_label = %HostReady
	_my_name_edit.editable = true
	_my_name_edit.placeholder_text = _default_name(Net.is_host)
	_my_name_edit.text = Net.my_name
	_my_name_edit.text_changed.connect(func(_text: String) -> void: _send_hello())

	%ReadyButton.pressed.connect(_on_ready_pressed)
	%LeaveButton.pressed.connect(_on_leave_pressed)
	%CopyButton.pressed.connect(_on_copy_pressed)
	Net.room_joined.connect(_on_room_joined)
	Net.message_received.connect(_on_message)
	Net.connection_failed.connect(_on_connection_failed)

	if Net.is_host:
		Net.host_game()
	else:
		Net.join_game(Net.wanted_code)
	if Net.state != Net.State.OFFLINE:
		%CodeLabel.text = "Game code: " + Net.room_code
	_update_view()


func _process(delta: float) -> void:
	if Net.state != Net.State.IN_ROOM:
		return

	_time_to_ping -= delta
	if _time_to_ping <= 0.0:
		_time_to_ping = ping_interval
		Net.send("ping")

	if other_id != "":
		_time_since_heard += delta
		if _time_since_heard > other_player_timeout:
			_other_player_left()
	elif not Net.is_host:
		_time_waiting_for_host += delta
		if _time_waiting_for_host > join_timeout:
			_fail("No game found with code %s. Check the code and try again." % Net.room_code)


func _on_room_joined() -> void:
	if Net.is_host:
		%CopyButton.visible = true
		%CopyButton.text = "Copy link" if Net.invite_link() != "" else "Copy code"
		%StatusLabel.text = "Waiting for a friend to join. Send them the code."
	else:
		%StatusLabel.text = "Looking for the host…"
	_send_hello()


func _on_message(event: String, data: Dictionary) -> void:
	var from: String = data.get("from", "")
	if from == other_id:
		_time_since_heard = 0.0

	match event:
		"hello":
			_on_hello(from, data)
		"full":
			if data.get("to", "") == Net.my_id:
				_fail("That game already has two players.")
		"start":
			if from == other_id and not Net.is_host:
				_start_countdown()
		"bye":
			if from == other_id:
				_other_player_left()


func _on_hello(from: String, data: Dictionary) -> void:
	var their_role: String = data.get("role", "")
	if other_id == "":
		# Only a host and a guest can pair up.
		var expected := "guest" if Net.is_host else "host"
		if their_role != expected:
			return
		other_id = from
		_time_since_heard = 0.0
		%StatusLabel.text = "Both players are here. Type your name and press Ready."
		_send_hello() # so the newcomer sees us straight away
	elif from != other_id:
		if Net.is_host and their_role == "guest":
			Net.send("full", {"to": from})
		return

	Net.other_name = str(data.get("name", ""))
	other_ready = bool(data.get("ready", false))
	_update_view()
	_maybe_start()


func _on_ready_pressed() -> void:
	my_ready = not my_ready
	_send_hello()
	_update_view()
	_maybe_start()


func _maybe_start() -> void:
	# Only the host decides, so both screens start together.
	if Net.is_host and my_ready and other_ready and other_id != "" and not counting_down:
		Net.send("start")
		_start_countdown()


func _start_countdown() -> void:
	counting_down = true
	_update_view()
	%StatusLabel.text = "Get ready!"
	%CountdownLabel.visible = true
	for n in range(countdown_from, 0, -1):
		%CountdownLabel.text = str(n)
		await _wait(1.0)
		if not counting_down:
			%CountdownLabel.visible = false
			return
	%CountdownLabel.text = "Go!"
	await _wait(0.5)
	if not counting_down:
		%CountdownLabel.visible = false
		return
	Net.my_name = _display_name(_my_name_edit.text, _default_name(Net.is_host))
	Net.other_name = _display_name(Net.other_name, _default_name(not Net.is_host))
	get_tree().change_scene_to_file("res://scenes/multiplayer_game.tscn")


func _other_player_left() -> void:
	counting_down = false
	%CountdownLabel.visible = false
	other_id = ""
	other_ready = false
	Net.other_name = ""
	if Net.is_host:
		%StatusLabel.text = "Your friend left. Waiting for someone to join…"
		_update_view()
	else:
		_fail("The host left the game.")


func _on_connection_failed(reason: String) -> void:
	_fail(reason)


func _fail(reason: String) -> void:
	counting_down = false
	%CountdownLabel.visible = false
	Net.leave()
	other_id = ""
	%StatusLabel.text = reason
	%ReadyButton.disabled = true
	%CopyButton.visible = false


func _on_leave_pressed() -> void:
	Net.leave()
	get_tree().change_scene_to_file("res://scenes/ui/multiplayer_menu.tscn")


func _on_copy_pressed() -> void:
	var link := Net.invite_link()
	DisplayServer.clipboard_set(link if link != "" else Net.room_code)
	%CopyButton.text = "Copied!"


func _send_hello() -> void:
	Net.send("hello", {
		"role": "host" if Net.is_host else "guest",
		"name": _my_name_edit.text,
		"ready": my_ready,
	})


func _update_view() -> void:
	var paired := other_id != ""
	_other_name_edit.text = Net.other_name if paired else ""
	_other_name_edit.placeholder_text = _default_name(not Net.is_host) if paired else "Waiting…"
	_other_ready_label.text = ("Ready!" if other_ready else "Not ready") if paired else ""
	_my_ready_label.text = "Ready!" if my_ready else "Not ready"
	_my_name_edit.editable = not counting_down
	%ReadyButton.disabled = not paired or counting_down
	%ReadyButton.text = "Not ready" if my_ready else "Ready"


## Waits a moment. Uses a Timer that belongs to this screen, so if the screen
## closes during the wait, the countdown simply stops.
func _wait(seconds: float) -> void:
	var timer := Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.start(seconds)
	await timer.timeout
	timer.queue_free()


## Player1 for the host, Player2 for the guest.
func _default_name(for_host: bool) -> String:
	return host_default_name if for_host else guest_default_name


func _display_name(text: String, fallback: String) -> String:
	var clean := text.strip_edges()
	return clean if clean != "" else fallback
