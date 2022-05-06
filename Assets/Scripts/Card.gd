extends TextureRect

class_name Card


var dp_string_ph = "Current DP: %s"
var dp_string = dp_string_ph % self.dp
var checks_string_ph = "Current Security Checks: %s"
var checks_string = checks_string_ph % self.checks
onready var menu = $PopupMenu

signal card_action_selected

#Card Data
var card_id
var card_name
var type
var play_cost
var color = []
var card_number
var main_effect
var secondary_effect
var dp
var level
var evolution_cost
var attribute
var digi_type
var stage
var checks
var remaining_checks
var max_checks
var card_data = {}
var card_back = load("res://Resources/Sprites/card_back.jpg")
var card_art

signal summoned(node_name)

var held = false
var selected = false
var sickness = false
var suspension = false
var phase

enum Zones {
	HAND = 0,
	DECK = 1,
	BABYDECK = 2,
	BREEDING = 3,
	TRASH = 4,
	SECURITY = 5,
	BATTLEAREA = 6,
	TAMERAREA = 7
}

var order_of_play
var owner_index
var zone = Zones.DECK


func _on_play_pressed():
	emit_signal("played", name)

func show_popup_menu(mouse_pos):
	menu.popup(Rect2(mouse_pos.x, mouse_pos.y, menu.rect_size.x, menu.rect_size.y))

func add_menu_items():
	if menu.get_item_count() != null || 0:
		menu.clear()
	if self.zone == Zones.HAND:
		menu.add_item("Play", 0)
		if type == "Digimon":
			menu.add_item("Digivolve", 1)
		if type == "Digimon" || type == "Tamer":
			menu.add_item("Activate Effect", 2)
	if self.zone == Zones.BATTLEAREA:
		menu.add_item("Activate Effect", 2)
	if self.zone == Zones.BREEDING && type == "digimon" && stage != "In-Training" && level > 2:
		menu.add_item("Move to Battle Area", 3)


func _on_PopupMenu_popup_hide():
	menu.clear()


func _on_PopupMenu_id_pressed(id):
	emit_signal("card_action_selected", id, self)
