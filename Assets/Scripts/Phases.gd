extends Node

class_name PhaseManager

onready var card_handler = get_parent().get_node("Card Handler")
onready var memory_counter = get_node("Game UI/UI Elements/Memory Container/Memory")
onready var phase_display = get_node("Game UI/UI Elements/Phase Container/Current Phase")
onready var end_turn = get_node("Game UI/UI Elements/End Turn")
onready var turn_display = get_node("Game UI/UI Elements/Turn Display/Turn Number")

var player_id

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
var turn_counter = 1
var turn_counter_string_ph = "Turn%s"
var turn_counter_string = turn_counter_string_ph % turn_counter
var memory

func next_phase():
	match phase:
		SETUP_PHASE:
			phase = FIRST_TURN_PHASE
			emit_signal("phase_change")
		FIRST_TURN_PHASE:
			phase = BREEDING_PHASE
			phase_display.text = "Breeding Phase"
			emit_signal("phase_change")
		UNSUSPEND_PHASE:
			phase = DRAW_PHASE
			phase_display.text = "Draw Phase"
			emit_signal("phase_change")
		DRAW_PHASE:
			phase = BREEDING_PHASE
			phase_display.text = "Breeding Phase"
			emit_signal("phase_change")
		BREEDING_PHASE:
			phase = MAIN_PHASE
			phase_display.text = "Main Phase"
			emit_signal("phase_change")
		MAIN_PHASE:
			if current_player == 1:
				current_player = 2
			elif current_player == 2:
				current_player = 1
			phase = UNSUSPEND_PHASE
			phase_display.text = "Unsuspend Phase"
			turn_counter += 1
			emit_signal("phase_change")
		END_PHASE:
			if current_player == 1:
				current_player = 2
			elif current_player == 2:
				current_player = 1
			phase = UNSUSPEND_PHASE
			phase_display.text = "Unsuspend Phase"
			emit_signal("phase_change")



func _on_Game_new_match():
	phase = SETUP_PHASE
	player_id = get_tree().get_network_unique_id()
	print("new match")
	emit_signal("phase_change")

func _on_Card_Handler_unsuspended_cards():
	if player_id == current_player:
		if player_id == 1:
			rpc("_remote_phase_change")
		else:
			rpc_id(1, "_client_end_phase")

func _on_Card_View_setup_done():
	if player_id == current_player:
		if player_id == 1:
			rpc("_remote_phase_change")
		else:
			rpc_id(1, "_client_end_phase")


func _on_Game_first_player(first_player):
	current_player = first_player

func _on_Card_View_first_turn_draws_done():
	if player_id == current_player:
		if player_id == 1:
			rpc("_remote_phase_change")
		else:
			rpc_id(1, "_client_end_phase")

func _on_Card_View_draw_complete():
	if phase == FIRST_TURN_PHASE || phase == DRAW_PHASE && player_id == current_player:
		if player_id == 1:
			rpc("_remote_phase_change")
		else:
			rpc_id(1, "_client_end_phase")

func _on_End_Turn_pressed():
	if player_id == current_player && phase == BREEDING_PHASE || phase == MAIN_PHASE:
		if player_id == 1:
			rpc("_remote_phase_change")
		else:
			rpc_id(1, "_client_end_phase")
	else:
		return

remote func _client_end_phase():
	rpc("_remote_phase_change")

remotesync func _remote_phase_change():
	next_phase()


func _on_Card_Handler_hatched_egg():
	next_phase()
