extends "res://Assets/Main/Screen.gd"

signal play_online

func _on_MultiButton_pressed() -> void:
	emit_signal("play_online")
