# Multiplayer menu: host a new game, or type a friend's code to join theirs.
# Both lead to the lobby, which makes the actual connection.
extends Control


func _ready() -> void:
	%HostButton.pressed.connect(_on_host)
	%JoinButton.pressed.connect(_on_join)
	%CodeEdit.text_submitted.connect(func(_text: String) -> void: _on_join())
	%BackButton.pressed.connect(_on_back)

	if not Net.is_configured():
		%StatusLabel.text = "Online play isn't set up yet (no Supabase project connected)."
		%HostButton.disabled = true
		%JoinButton.disabled = true


func _on_host() -> void:
	Net.is_host = true
	Net.wanted_code = ""
	get_tree().change_scene_to_file("res://scenes/ui/lobby.tscn")


func _on_join() -> void:
	var code := Net.clean_code(%CodeEdit.text)
	if code.length() != Net.CODE_LENGTH:
		%StatusLabel.text = "Type the %d-letter code your friend sees." % Net.CODE_LENGTH
		return
	Net.is_host = false
	Net.wanted_code = code
	get_tree().change_scene_to_file("res://scenes/ui/lobby.tscn")


func _on_back() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")
