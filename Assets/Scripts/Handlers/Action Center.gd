extends Node

onready var card_view = get_node("Zones/Card View")
onready var phases = get_parent().get_node("Phase Manager")


signal drawn_card
signal enemy_drawn_card
signal unsuspended_cards
signal hatched_egg

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

func unsuspend_all():
	print("unsuspended")
	emit_signal("unsuspended_cards")

func draw_card(amount):
	for n in amount:
		var drawn_card = card_view.deck_cards.back()
		drawn_card.connect("card_action_selected", card_view, "_on_card_action_selected")
		card_view.deck_cards.pop_back()
		drawn_card.zone = drawn_card.Zones.HAND
		card_view.hand_cards.append(drawn_card)
		card_view._on_Card_Handler_drawn_card()
	emit_signal("drawn_card")

func enemy_draw_card(amount):
	for n in amount:
		var enemy_drawn_card = card_view.enemy_cards.back()
		card_view.enemy_cards.pop_back()
		enemy_drawn_card.zone = enemy_drawn_card.Zones.HAND
		card_view.enemy_hand.append(enemy_drawn_card)
		card_view._on_Card_Handler_enemy_draw_card()
	emit_signal("enemy_drawn_card")

remote func _enemy_draw(amount):
	for n in amount:
		var enemy_drawn_card = card_view.enemy_cards.back()
		card_view.enemy_cards.pop_back()
		enemy_drawn_card.zone = enemy_drawn_card.Zones.HAND
		card_view.enemy_hand.append(enemy_drawn_card)
		card_view._on_Card_Handler_enemy_draw_card()
	emit_signal("enemy_drawn_card")

remote func _draw(amount):
	for n in amount:
		var drawn_card = card_view.deck_cards.back()
		card_view.deck_cards.pop_back()
		drawn_card.zone = drawn_card.Zones.HAND
		card_view.hand_cards.append(drawn_card)
		card_view._on_Card_Handler_drawn_card()
	emit_signal("drawn_card")

func hatch_egg():
	card_view.breeding_cards.append(card_view.baby_deck.pop_back())
	#for f in (card_view.enemy_hand):
	#	print(f.card_name)
	#print("***********")
	#for f in (card_view.hand_cards):
	#	print(f.card_name)
#	print("***********")
	#for f in (card_view.deck_cards):
	#	print(f.card_name)
	emit_signal("hatched_egg")

func _on_Phase_Manager_phase_change():
	var player_id = get_tree().get_network_unique_id()
	match phases.phase:
		phases.FIRST_TURN_PHASE:
			if player_id == 1:
				draw_card(5)
				enemy_draw_card(5)
				rpc_id(2, "_draw", 5)
				rpc_id(2, "_enemy_draw", 5)
		phases.UNSUSPEND_PHASE:
			unsuspend_all()
		phases.BREEDING_PHASE:
			if card_view.breeding_cards.empty():
				hatch_egg()
		phases.DRAW_PHASE:
			print(phases.current_player)
			if player_id == 1:
				if phases.current_player == player_id:
					draw_card(1)
					rpc_id(2, "_enemy_draw", 1)
			if player_id == 1:
				if phases.current_player != player_id:
					enemy_draw_card(1)
					rpc_id(2, "_draw", 1)

func play_card():
	pass
