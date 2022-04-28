extends Node

class_name Game

var Player = preload("res://Assets/Player/Player.tscn")

var game_started

var game_over
var players_alive = {}
var players_setup = {}

onready var online_match = get_node("/root/OnlineMatch")
onready var phases = get_node("Phase Manager")
onready var players_node = $Players
onready var board = get_node("Background/Board")
onready var counter = get_node("Ui/Counter")
onready var end_turn = get_node("Ui/End Turn Test")
onready var card_view = get_node("Card Handler/Zones/Card View")

var player_index

var current_player

signal new_match
signal player_dead(player_id)
signal game_over(player_id)

remotesync func _match_start(players: Dictionary) -> void:
	get_tree().set_pause(true)
	
	game_started = true
	game_over = false
	
	rpc("_reload_board")
	rpc("_flip_board")
	
	player_index = 1
	for peer_id in players:
		var other_player = Player.instance()
		other_player.name = str(peer_id)
		players_node.add_child(other_player)
		
		other_player.set_network_master(peer_id)
		
		player_index += 1
		print(other_player.name)
	
	if GameState.online_play:
		var my_id = get_tree().get_network_unique_id()
		var my_player = players_node.get_node(str(my_id))
		print(my_player)
		rpc("_finished_game_setup")
		
remotesync func _finished_game_setup() -> void:
		get_tree().set_pause(false)
		emit_signal("new_match")
		print("game start")


remote func _flip_board() -> void:
	board.flip_v = true

remotesync func _reload_board() -> void:
	board.visible = true
	counter.visible = true
	card_view.visible = true
	end_turn.visible = true
