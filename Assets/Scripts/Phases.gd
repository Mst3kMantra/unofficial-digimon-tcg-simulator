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
FIRST_TURN_PHASE = 8
}

var phase = PAUSE_PHASE
var has_hatched = false
var current_phase
signal phase_change
var current_player


func next_phase():
	match phase:
		SETUP_PHASE:
			phase = FIRST_TURN_PHASE
			emit_signal("phase_change")
		FIRST_TURN_PHASE:
			phase = DRAW_PHASE
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
			if current_player == 1:
				current_player = 2
			elif current_player == 2:
				current_player = 1
			phase = UNSUSPEND_PHASE
			emit_signal("phase_change")
		END_PHASE:
			if current_player == 1:
				current_player = 2
			elif current_player == 2:
				current_player = 1
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



func _on_Card_View_setup_done():
	next_phase()


func _on_Game_first_player(first_player):
	current_player = first_player



func _on_Card_View_first_turn_draws_done():
	next_phase()


func _on_Card_View_draw_complete():
	if phase == FIRST_TURN_PHASE:
		next_phase()
	if phase == DRAW_PHASE:
		next_phase()
