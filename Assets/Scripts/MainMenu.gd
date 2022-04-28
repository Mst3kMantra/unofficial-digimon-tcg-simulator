extends "res://Assets/Main/Screen.gd"

signal play_online
signal save_load

func _on_MultiButton_pressed() -> void:
	emit_signal("play_online")


func _on_Saveloadbutton_pressed():
	emit_signal("save_load")
