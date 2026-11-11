# Placeholder scene. It only proves the project runs on a Mac, in the browser
# and on an iPhone: a square you move with the arrow keys or by dragging.
# Replace it once we have chosen our game.
extends Node2D

## How fast the square moves, in pixels per second.
@export var speed: float = 400.0
## Width and height of the square, in pixels.
@export var square_size: float = 64.0
## Colour of the square.
@export var square_color: Color = Color("4c9be8")
## Text shown in the top-left corner.
@export var message: String = "It works! Arrow keys or drag to move."

var square_position: Vector2
var drag_target: Variant = null # Vector2 while a finger or the mouse is down


func _ready() -> void:
	square_position = get_viewport_rect().size / 2.0


func _process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction != Vector2.ZERO:
		drag_target = null
		square_position += direction * speed * delta
	elif drag_target != null:
		square_position = square_position.move_toward(drag_target, speed * delta)

	var half := Vector2.ONE * square_size / 2.0
	square_position = square_position.clamp(half, get_viewport_rect().size - half)
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	# Touch on iPhone; mouse clicks count as touch too (see project settings).
	if event is InputEventScreenTouch and event.pressed:
		drag_target = event.position
	elif event is InputEventScreenDrag:
		drag_target = event.position


func _draw() -> void:
	var half := Vector2.ONE * square_size / 2.0
	draw_rect(Rect2(square_position - half, half * 2.0), square_color)
	draw_string(ThemeDB.fallback_font, Vector2(24, 48), message,
			HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color.WHITE)
