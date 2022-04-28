extends Control

onready var list = $ItemList
onready var load_button = $Load
onready var load_message = $"Load notification"

var deck_list = {}
var loaded_deck = []
var decks = []
# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	if file.file_exists("user://saved_decks.dat"):
		file.open("user://saved_decks.dat", File.READ)
		deck_list = file.get_var()
		decks = deck_list.keys()
		for f in decks:
			list.add_item(str(f), null)
		file.close()
		



func _on_TabContainer_tab_changed(tab):
	if tab == 1:
		var file = File.new()
		if file.file_exists("user://saved_decks.dat"):
			file.open("user://saved_decks.dat", File.READ)
			deck_list = file.get_var()
			decks = deck_list.keys()
			list.clear()
			for f in decks:
				list.add_item(str(f), null)
			file.close()


func _on_Load_pressed():
	var selected_deck = list.get_selected_items()
	if selected_deck.empty():
		return
	var unfucked_deck = []
	for k in deck_list[decks[selected_deck[0]]]:
		k.replace('\"', '')
		unfucked_deck.append(k)
	DefaultDeck.default_deck = unfucked_deck
	load_message.text = "Load successful..."
