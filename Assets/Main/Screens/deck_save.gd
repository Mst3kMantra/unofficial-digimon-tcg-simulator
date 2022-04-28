extends Node

onready var save_button = $Save
onready var import = $Import
onready var deck_name = $"Deck Name"
onready var save_message = $"Save notification"
var deck_dict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Save_pressed():
	var import_string = import.text
	var save_name = deck_name.text
	import_string = import_string.replace('[', '')
	import_string = import_string.replace(']', '')
	import_string = import_string.replace('"', '')
	var array = import_string.split(',')
	array.remove(0)
	deck_dict = {save_name : array}
	var file = File.new()
	if file.file_exists("user://saved_decks.dat"):
		file.open("user://saved_decks.dat", File.READ)
		var load_dict = file.get_var()
		file.close()
		file.open("user://saved_decks.dat", File.WRITE)
		load_dict[save_name] = array
		file.store_var(load_dict)
		file.close()
		save_message.text = "Save successful..."
	else:
		file.open("user://saved_decks.dat", File.WRITE)
		file.store_var(deck_dict)
		file.close()
		save_message.text = "Save successful..."
