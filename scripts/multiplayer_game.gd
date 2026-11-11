# Multiplayer game: two squares, one per player. You move your own square
# (arrow keys, or click/touch where it should go); the other player's square
# moves on your screen as they move it on theirs. The host starts on the
# left in blue, the guest on the right in orange.
#
# Messages (sent with Net.send):
#   "pos"   {x, y}   where my square is, several times a second
#   "ping"  {}       "still here" (sent by the lobby too)
#   "bye"   {}       sent automatically when a player leaves
extends Node2D

## How fast your square moves, in pixels per second.
@export var speed: float = 400.0
## Width and height of each square, in pixels.
@export var square_size: float = 64.0
## Colour of the host's square.
@export var host_color: Color = Color("4c9be8")
## Colour of the guest's square.
@export var guest_color: Color = Color("f29a40")
## How many times per second we tell the other player where we are.
@export var sends_per_second: float = 15.0
## How quickly the other square catches up with its latest known spot.
## Higher is snappier, lower is smoother.
@export var smoothing: float = 15.0
## Seconds without any message before we decide the other player has gone.
@export var other_player_timeout: float = 5.0

var my_position: Vector2
var other_position: Vector2
var other_target: Vector2
var drag_target: Variant = null # Vector2 while a finger or the mouse is down
var game_over := false

var _time_to_send := 0.0
var _time_since_heard := 0.0


func _ready() -> void:
	var screen := get_viewport_rect().size
	var left := Vector2(screen.x / 3.0, screen.y / 2.0)
	var right := Vector2(screen.x * 2.0 / 3.0, screen.y / 2.0)
	my_position = left if Net.is_host else right
	other_position = right if Net.is_host else left
	other_target = other_position

	%LeaveButton.pressed.connect(_back_to_menu)
	%MenuButton.pressed.connect(_back_to_menu)
	Net.message_received.connect(_on_message)
	Net.connection_failed.connect(func(reason: String) -> void: _end(reason))


func _process(delta: float) -> void:
	if not game_over:
		_move_my_square(delta)
		_time_to_send -= delta
		if _time_to_send <= 0.0:
			_time_to_send = 1.0 / sends_per_second
			Net.send("pos", {"x": my_position.x, "y": my_position.y})
		_time_since_heard += delta
		if _time_since_heard > other_player_timeout:
			_end("Lost contact with %s." % Net.other_name)

	# Glide towards the latest spot we heard about, so it looks smooth.
	other_position = other_position.lerp(other_target, minf(1.0, smoothing * delta))
	queue_redraw()


func _move_my_square(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction != Vector2.ZERO:
		drag_target = null
		my_position += direction * speed * delta
	elif drag_target != null:
		my_position = my_position.move_toward(drag_target, speed * delta)
	var half := Vector2.ONE * square_size / 2.0
	my_position = my_position.clamp(half, get_viewport_rect().size - half)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		drag_target = event.position
	elif event is InputEventScreenDrag:
		drag_target = event.position


func _on_message(event: String, data: Dictionary) -> void:
	_time_since_heard = 0.0
	match event:
		"pos":
			other_target = Vector2(float(data.get("x", 0.0)), float(data.get("y", 0.0)))
		"bye":
			_end("%s left the game." % Net.other_name)


func _end(reason: String) -> void:
	if game_over:
		return
	game_over = true
	Net.leave()
	%NoticeLabel.text = reason
	%NoticeBox.visible = true
	%LeaveButton.visible = false


func _back_to_menu() -> void:
	Net.leave()
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")


func _draw() -> void:
	var my_color := host_color if Net.is_host else guest_color
	var other_color := guest_color if Net.is_host else host_color
	_draw_player(other_position, other_color, Net.other_name)
	_draw_player(my_position, my_color, Net.my_name + " (you)")


func _draw_player(pos: Vector2, color: Color, label: String) -> void:
	var half := Vector2.ONE * square_size / 2.0
	draw_rect(Rect2(pos - half, half * 2.0), color)
	var font := ThemeDB.fallback_font
	var font_size := 24
	var width := font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
	draw_string(font, pos + Vector2(-width / 2.0, -half.y - 12.0), label,
			HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color.WHITE)
