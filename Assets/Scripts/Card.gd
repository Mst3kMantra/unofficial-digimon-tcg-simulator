extends TextureRect

class_name Card


var dp_string_ph = "Current DP: %s"
var dp_string = dp_string_ph % self.dp
var checks_string_ph = "Current Security Checks: %s"
var checks_string = checks_string_ph % self.checks

#Card Data
var id
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

var order_of_play
var owner_index
#var zone = Player.Zones.DECK


func _on_Summon_pressed():
	emit_signal("summoned", name)

