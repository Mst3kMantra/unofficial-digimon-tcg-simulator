extends Node

class_name PhaseManager

onready var card_handler = get_parent().get_node("Card Handler")

enum {
UNSUSPEND_PHASE = 0
DRAW_PHASE = 1,
BREEDING_PHASE = 2, 
MAIN_PHASE = 3, 
END_PHASE = 4,
PAUSE_PHASE = 5, 
DAMAGE_STEP = 6,
SETUP_PHASE = 7
}

var phase = PAUSE_PHASE
var has_hatched = false
signal phase_change


func next_phase():
	match phase:
		SETUP_PHASE:
			phase = UNSUSPEND_PHASE
			emit_signal("phase_change")
		UNSUSPEND_PHASE:
			phase = DRAW_PHASE
			emit_signal("phase_change")
		DRAW_PHASE:
			phase = BREEDING_PHASE
			emit_signal("phase_change")
		BREEDING_PHASE:
			phase = MAIN_PHASE
			emit_signal("phase_change")
		MAIN_PHASE:
			phase = UNSUSPEND_PHASE
			emit_signal("phase_change")
		END_PHASE:
			phase = UNSUSPEND_PHASE
			emit_signal("phase_change")




func _on_Game_new_match():
	phase = SETUP_PHASE
	print("new match")
	emit_signal("phase_change")



func _on_Card_Handler_unsuspended_cards():
	next_phase()


func _on_End_Turn_Test_button_down():
	next_phase()


func _on_Card_Handler_drawn_card():
	if phase == DRAW_PHASE:
		next_phase()


func _on_Card_View_setup_done():
	next_phase()
