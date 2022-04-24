extends Node



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_down():
	var text = $TextEdit.text
	text = text.replace('[', '')
	text = text.replace(']', '')
	var array = text.split(',')
	array.remove(0)
	print(array)

