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

#Phases
enum {
UNSUSPEND_PHASE
DRAW_PHASE,
BREEDING_PHASE, 
MAIN_PHASE, 
END_PHASE,
PAUSE_PHASE, 
DAMAGE_STEP,
UNSUSPEND_PHASE_ENEMY, 
DRAW_PHASE_ENEMY,
BREEDING_PHASE_ENEMY, 
MAIN_PHASE_ENEMY, 
END_PHASE_ENEMY}

signal mouse_entered_in_hand(node_name)
signal mouse_exited_in_hand(node_name)
signal summoned(node_name)

var held = false
var selected = false
var phase
var can_summon = false

var orderOfPlay
var ownerIndex
#var zone = Player.Zones.DECK


func _on_Card_mouse_entered():
	if selected:
		return
	emit_signal("mouse_entered_in_hand", name)


func _on_Card_mouse_exited():
	if selected:
		return
	emit_signal("mouse_exited_in_hand", name)

func _on_Summon_pressed():
	emit_signal("summoned", name)

