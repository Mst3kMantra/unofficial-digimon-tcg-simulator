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
UNSUSPEND_PHASE_ENEMY = 7, 
DRAW_PHASE_ENEMY = 8,
BREEDING_PHASE_ENEMY = 9, 
MAIN_PHASE_ENEMY = 10, 
END_PHASE_ENEMY = 11
}

var phase = PAUSE_PHASE
var has_hatched = false
signal phase_change


func next_phase():
	match phase:
		UNSUSPEND_PHASE:
			phase = DRAW_PHASE
			emit_signal("phase_change")
		DRAW_PHASE:
			phase = MAIN_PHASE
			emit_signal("phase_change")
			print(phase)
		MAIN_PHASE:
			phase = UNSUSPEND_PHASE
			print(phase)
			emit_signal("phase_change")
		END_PHASE:
			emit_signal("phase_change")
			phase = UNSUSPEND_PHASE
			
			



func _on_Game_new_match():
	phase = UNSUSPEND_PHASE
	print("new match")
	emit_signal("phase_change")



func _on_Card_Handler_unsuspended_cards():
	next_phase()


func _on_End_Turn_Test_button_down():
	next_phase()


func _on_Card_Handler_drawn_card():
	if phase == DRAW_PHASE:
		next_phase()
