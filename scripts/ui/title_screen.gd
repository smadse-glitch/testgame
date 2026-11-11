# Title screen: the first thing you see. Single player starts the game as it
# was; Multiplayer opens the host/join menu. In the web version, a link with
# ?join=CODE skips straight to that game's lobby.
extends Control


func _ready() -> void:
	%SinglePlayerButton.pressed.connect(_on_single_player)
	%MultiplayerButton.pressed.connect(_on_multiplayer)

	var code := Net.code_from_page_address()
	if code != "":
		Net.clear_page_address()
		Net.is_host = false
		Net.wanted_code = code
		get_tree().change_scene_to_file.call_deferred("res://scenes/ui/lobby.tscn")


func _on_single_player() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_multiplayer() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/multiplayer_menu.tscn")
