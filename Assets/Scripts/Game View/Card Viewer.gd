extends Node2D


#nodes
onready var deck_loader = get_parent().get_node("Deck Loader")
onready var deck_zone = get_node("Player1/Deck")
onready var enemy_deck_zone = get_node("Player2/Deck2")
onready var phases = get_node("/root/Main/Game/Phase Manager")
#card zones
var hand_cards = []
var enemy_hand = []
var deck_cards = []
var enemy_cards = []
var trash_cards = []
var enemy_trash = []
var baby_deck = []
var enemy_baby = []
var breeding_cards = []
var enemy_breeding = []
var security_cards = []
var enemy_security = []
var slot_1 = []
var slot_2 = []
var slot_3 = []
var slot_4 = []
var slot_5 = []
var slot_6 = []
var slot_7 = []
var slot_8 = []
var slot_9 = []
var slot_10 = []
var tamer_1 = []
var tamer_2 = []
var tamer_3 = []
var tamer_4 = []
var tamer_5 = []
var tamer_6 = []
var tamer_7 = []
var tamer_8 = []
var tamer_9 = []
var tamer_10 = []
var battle_area = [slot_1, slot_2, slot_3, slot_4, slot_5, slot_6, slot_7, slot_8, slot_9, slot_10,
 tamer_1, tamer_2, tamer_3, tamer_4, tamer_5, tamer_6, tamer_7, tamer_8, tamer_9, tamer_10]
var enemy_slot_1 = []
var enemy_slot_2 = []
var enemy_slot_3 = []
var enemy_slot_4 = []
var enemy_slot_5 = []
var enemy_slot_6 = []
var enemy_slot_7 = []
var enemy_slot_8 = []
var enemy_slot_9 = []
var enemy_slot_10 = []
var enemy_tamer_1 = []
var enemy_tamer_2 = []
var enemy_tamer_3 = []
var enemy_tamer_4 = []
var enemy_tamer_5 = []
var enemy_tamer_6 = []
var enemy_tamer_7 = []
var enemy_tamer_8 = []
var enemy_tamer_9 = []
var enemy_tamer_10 = []
var enemy_battle_area = [enemy_slot_1, enemy_slot_2, enemy_slot_3, enemy_slot_4, enemy_slot_5, enemy_slot_6, enemy_slot_7, enemy_slot_8, enemy_slot_9, enemy_slot_10
, enemy_tamer_1, enemy_tamer_2, enemy_tamer_3, enemy_tamer_4, enemy_tamer_5, enemy_tamer_6, enemy_tamer_7, enemy_tamer_8, enemy_tamer_9, enemy_tamer_10]
#card metadata
var card_art_string_format = "res://Resources/Sprites/%s.jpg"
var start_pos = []
var start_pos_y = []
var shifted_pos_left = []
var shifted_pos_right = []
var card_check
var setup_is_done = false
#signals
signal card_changed
signal setup_done
signal draw_complete
#card name generator
var card_string_format = "card%s"
var card_name_index = 0
var enemy_card_string_format = "enemy_card%s"
var enemy_card_name_index = 0
#seed
var random_number

#pos
onready var center_hand = get_viewport_rect().size/2 + Vector2(card_offset.x/1.5 + 1200,0) + Vector2(0,card_offset.y * 1.5)
onready var enemy_center_hand = get_viewport_rect().size/2 + Vector2(enemy_card_offset.x/1.5 + 1200,0) - Vector2(0,enemy_card_offset.y * 1.5)
onready var mouse_check = false

var card_offset = Vector2(300,800)
var enemy_card_offset = Vector2(0,800)
var card_margin = card_offset.x/1.1

#card actions
var playing_card = false
var current_card
# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	self.connect("card_changed", self, "_on_card_change")

var result

#polling function to check targets
func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	result = space_state.intersect_ray(mouse_position, mouse_position, [], 2147483647, true, true)
	if result.has("collider") && setup_is_done == true:
		if Input.is_action_just_pressed("click") && result.size() != 0 && result["collider"].get_parent().has_method("show_popup_menu") && result["collider"].get_parent().owner_index == 1 && playing_card == false:
			var selected_card = result["collider"].get_parent()
			var last_mouse_pos = get_global_mouse_position()
			if selected_card.is_menu_hidden == true && playing_card == false:
				selected_card.add_menu_items()
				selected_card.show_popup_menu(last_mouse_pos)
	var count = hand_cards.size()
	if phases.phase == 8 || phases.phase == 7 || hand_cards.empty() || setup_is_done == false:
		return
	if result.size() == 0 && hand_cards.empty() == false && start_pos.empty() == false && start_pos_y.empty() == false:
		emit_signal("card_changed")
	if result.size() != 0 && mouse_position.y > 780 && mouse_position.y < 1300 && result["collider"].get_parent().get_parent().name == "Pile" && result["collider"].get_parent().zone == 0:
		if card_check != result["collider"].get_parent():
			emit_signal("card_changed")
		card_check = result["collider"].get_parent()
		var card_index = hand_cards.find(card_check)
		var tween_hover = card_check.get_node("Hover")
		var tween_draw = card_check.get_node("Draw")
		var tween_move_left = card_check.get_node("Move Left")
		var tween_move_right = card_check.get_node("Move Right")
		var tween_move_back = card_check.get_node("Move Back")
		var area = card_check.get_node("Area2D")
		if tween_draw.is_active() == true:
			return
		if tween_move_left.is_active() == true:
			return
		if tween_move_right.is_active() == true:
			return
			#make loop to check if each card has returned to start position before moving them
			#try getting mouse position vs on mouse enter
		else:
			if count > 1:
				for j in count:
					if start_pos.size() != hand_cards.size():
						break
					if tween_move_left.is_active() || tween_move_right.is_active():
						tween_move_left.reset_all()
						tween_move_right.reset_all()
					if tween_move_back.is_active():
						break
					var neighbor_card = hand_cards[j]
					if neighbor_card != card_check && j < card_index:
						tween_move_left.interpolate_property(
							neighbor_card, "rect_position",
							neighbor_card.rect_position, Vector2(shifted_pos_left[j], center_hand.y),
							0.2 * delta, Tween.TRANS_QUINT)
						tween_move_left.start()
					if neighbor_card != card_check && j > card_index:
						tween_move_right.interpolate_property(
							neighbor_card, "rect_position",
							neighbor_card.rect_position, Vector2(shifted_pos_right[j], center_hand.y),
							0.2 * delta, Tween.TRANS_QUINT)
						tween_move_right.start()
			if tween_draw.is_active():
				return
			tween_hover.interpolate_property(
				card_check, "rect_scale",
				card_check.rect_scale, Vector2(1.5,1.5), 0.1 * delta,
				Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
			tween_hover.interpolate_property(
				area, "scale",
				area.scale, Vector2(1.5,1.5), 0.1 * delta,
				Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
			tween_hover.interpolate_property(
				card_check, "rect_position",
				card_check.rect_position, Vector2(card_check.rect_position.x, center_hand.y * 0.8), 0.1 * delta,
				Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
			tween_hover.start()

func _input(event):
	if event.is_action_pressed("click"):
		if playing_card && result.has("collider") && setup_is_done:
			var selected_zone = result["collider"].get_parent()
			var current_card_index = hand_cards.find(current_card)
			if phases.phase == phases.MAIN_PHASE:
				for f in range(1,10):
					if selected_zone.name == "slot_%s" % str(f) && current_card.type != "Tamer":
						hand_cards[current_card_index].zone = current_card.Zones.BATTLEAREA
						battle_area[f - 1].append(hand_cards.pop_at(current_card_index))
						play_card(selected_zone)
					if selected_zone.name == "tamer_%s" % str(f) && current_card.type == "Tamer":
						hand_cards[current_card_index].zone = current_card.Zones.BATTLEAREA
						battle_area[f - 1 + 10].append(hand_cards.pop_at(current_card_index))
						play_card(selected_zone)
				print(current_card)
				playing_card = false

remote func network_play_card(played_card, zone):
	var current_card_index = enemy_hand.find(played_card)
	for f in range(1,10):
					if zone.name == "slot_%s" % str(f) && current_card.type != "Tamer":
						hand_cards[current_card_index].zone = current_card.Zones.BATTLEAREA
						battle_area[f - 1].append(hand_cards.pop_at(current_card_index))
						var selected_zone = get_node(("enemy_slot_%s" % str(f)))
						play_card(selected_zone)
					if zone.name == "tamer_%s" % str(f) && current_card.type == "Tamer":
						hand_cards[current_card_index].zone = current_card.Zones.BATTLEAREA
						battle_area[f - 1 + 10].append(hand_cards.pop_at(current_card_index))
						var selected_zone = get_node(("enemy_tamer_%s" % str(f)))
						play_card(selected_zone)


func _on_card_action_selected(id, calling_card):
	current_card = calling_card
	if id == 0 && phases.phase == 3:
		playing_card = true
		print("play card")

func get_seed():
	random_number = randi()
	rpc_id(2, "_send_seed", random_number)

remote func _send_seed(random_seed):
	random_number = random_seed
	setup_deck()

func _on_Deck_Loader_deck_loaded():
	if get_tree().get_network_unique_id() == 1:
		get_seed()
		setup_deck()

remote func shuffle_cards(cards):
	var shuffled_cards = []
	var index_list = range(cards.size())
	for _i in range(cards.size()):
		var x = randi()%index_list.size()
		shuffled_cards.append(cards[index_list[x]])
		cards.remove(x)

func setup_deck():
	seed(random_number)
	deck_cards = deck_loader.deck
	enemy_cards = deck_loader.enemy_deck
	var j = 0
	while j < (enemy_cards.size()):
		var type = enemy_cards[j].type
		if type == "Digi-Egg" || enemy_cards[j].stage == "In-Training" || enemy_cards[j].level == 2:
			enemy_cards[j].zone = enemy_cards[j].Zones.BABYDECK
			enemy_baby.append(enemy_cards.pop_at(j))
			j = 0
		j += 1
	var i = 0
	while i < (deck_cards.size()):
		var type = deck_cards[i].type
		if type == "Digi-Egg" || deck_cards[i].stage == "In-Training" || deck_cards[i].level == 2:
			deck_cards[i].zone = deck_cards[i].Zones.BABYDECK
			baby_deck.append(deck_cards.pop_at(i))
			i = 0
		i += 1
	for k in (5):
		var security_set = deck_cards.back()
		var enemy_security_set = enemy_cards.back()
		security_set.zone = security_set.Zones.SECURITY
		security_cards.append(deck_cards.pop_back())
		enemy_security_set.zone = enemy_security_set.Zones.SECURITY
		enemy_security.append(enemy_cards.pop_back())
	if get_tree().get_network_unique_id() == 1:
		rpc("_setup_done")

remotesync func _setup_done():
	emit_signal("setup_done")

func loop_cards(numbers, temp_deck, deck):
	var i = 0
	while i < numbers.size():
		for f in temp_deck:
			if f.get("card_number") == str(numbers[i]):
				deck.append(f)
				break
		i += 1
#todo find index numbers of deck_cards and enemy_cards to each array then use pop_at() to move those cards into the
#correct order of the master shuffle

func _on_card_change():
	if phases.phase == 8 || phases.phase == 7 || hand_cards.empty():
		return
	var count = hand_cards.size()
	if setup_is_done:
		for j in count:
			var card = hand_cards[j]
			var tween_shrink = card.get_node("Shrink")
			var tween_move_back = card.get_node("Move Back")
			var tween_draw = card.get_node("Draw")
			var area = card.get_node("Area2D")
			if tween_shrink.is_active() || tween_draw.is_active():
				return
			tween_shrink.interpolate_property(
				card, "rect_scale",
				card.rect_scale, Vector2(1,1), 0.1,
			Tween.TRANS_QUINT)
			tween_shrink.interpolate_property(
				area, "scale",
				area.scale, Vector2(1,1), 0.1,
			Tween.TRANS_QUINT)
			tween_shrink.start()
			if start_pos == null:
				return
			if count != start_pos.size():
				return
			if tween_move_back.is_active() == true:
				tween_move_back.reset_all()
			tween_move_back.interpolate_property(
				card, "rect_position",
				card.rect_position, Vector2(start_pos[j], start_pos_y[j]),
				.1, Tween.TRANS_QUINT)
			tween_move_back.start()

func play_card(zone):
	var tween_play = current_card.get_node("PlayCard")
	var tween_shrink = current_card.get_node("Shrink")
	var cards_in_hand = hand_cards.size()
	var center_of_cards = (hand_cards.size() * card_margin - current_card.rect_size.x)/1.5
	for i in cards_in_hand:
		var card = hand_cards[i]
		tween_play.interpolate_property(
			card, "rect_position",
			card.rect_position, Vector2(center_hand.x - center_of_cards + i * card_margin, center_hand.y),
			0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)

	

	tween_shrink.interpolate_property(
		current_card, "rect_scale",
		current_card.rect_scale, Vector2(.8,.8), 0.1,
	Tween.TRANS_QUINT)
	tween_shrink.interpolate_property(
		current_card.get_node("Area2D"), "scale",
		current_card.get_node("Area2D").scale, Vector2(.8,.8), 0.1,
	Tween.TRANS_QUINT)
	tween_shrink.start()
	
	tween_play.interpolate_property(
	current_card, "rect_position",
	current_card.rect_position, Vector2(zone.rect_position.x, zone.rect_position.y),
	0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween_play.start()
	yield(tween_play, "tween_all_completed")
	get_start_pos()
	current_card.rect_scale = Vector2(0.8,0.8)
	current_card.get_node("Area2D").scale = Vector2(0.8,0.8)

func _on_Card_Handler_drawn_card():
	var deck_position = deck_zone.rect_position
	var drawn_card = hand_cards.back()
	var card_art_string = card_art_string_format % drawn_card.card_number
	drawn_card.card_art = load(card_art_string)
	drawn_card.texture = drawn_card.card_art
	var tween_draw = drawn_card.get_node("Draw")
	var cards_in_hand = hand_cards.size()
	var center_of_cards = (hand_cards.size() * card_margin - drawn_card.rect_size.x)/1.5
	for i in cards_in_hand:
		var card = hand_cards[i]
		tween_draw.interpolate_property(
			card, "rect_position",
			card.rect_position, Vector2(center_hand.x - center_of_cards + i * card_margin, center_hand.y),
			0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	var name_card_string = card_string_format % card_name_index
	drawn_card.set_name(name_card_string)
	card_name_index += 1
	drawn_card.set_network_master(1)
	if drawn_card.get_parent():
		drawn_card.get_parent().remove_child(drawn_card)
		self.get_node("Pile").add_child(drawn_card)
	self.get_node("Pile").add_child(drawn_card)
	if get_tree().get_network_unique_id() == 2:
		for f in hand_cards:
			if f.get_parent() == null:
				self.get_node("Pile").add_child(f)

	drawn_card.rect_position = deck_position

	tween_draw.interpolate_property(
		drawn_card, "rect_position",
		deck_zone.rect_position, Vector2(center_hand.x - center_of_cards + cards_in_hand * card_margin - drawn_card.rect_size.x/1.5, center_hand.y),
		0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween_draw.start()
	yield(tween_draw, "tween_all_completed")
	get_start_pos()
	setup_is_done = true
	emit_signal("draw_complete")


func get_start_pos():
	if start_pos != null:
		start_pos.clear()
		start_pos_y.clear()
		shifted_pos_left.clear()
		shifted_pos_right.clear()
	for i in hand_cards.size():
		start_pos.append(hand_cards[i].rect_position.x)
		start_pos_y.append(hand_cards[i].rect_position.y)
		shifted_pos_left.append(hand_cards[i].rect_position.x - hand_cards[i].rect_size.x / 2)
		shifted_pos_right.append(hand_cards[i].rect_position.x + hand_cards[i].rect_size.x/ 2)


func _on_Card_Handler_enemy_draw_card():
	var enemy_deck_position = enemy_deck_zone.rect_position
	var drawn_card = enemy_hand.back()
	var card_art_string = card_art_string_format % drawn_card.card_number
	drawn_card.card_art = load(card_art_string)
	drawn_card.texture = drawn_card.card_back
	drawn_card.flip_v = true
	var tween_draw = drawn_card.get_node("EnemyDraw")
	var cards_in_hand = enemy_hand.size()
	var center_of_cards = (enemy_hand.size() * card_margin - drawn_card.rect_size.x)/1.5
	for i in cards_in_hand:
		var card = enemy_hand[i]
		tween_draw.interpolate_property(
			card, "rect_position",
			card.rect_position, Vector2(enemy_center_hand.x - center_of_cards + i * card_margin, enemy_center_hand.y),
			0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	var enemy_card_string = enemy_card_string_format % enemy_card_name_index
	drawn_card.set_name(enemy_card_string)
	drawn_card.set_network_master(1)
	if drawn_card.get_parent():
		drawn_card.get_parent().remove_child(drawn_card)
		self.get_node("Pile").add_child(drawn_card)
	self.get_node("Pile").add_child(drawn_card)
	if get_tree().get_network_unique_id() == 2:
		for f in hand_cards:
			if f.get_parent() == null:
				self.get_node("Pile").add_child(f)
	drawn_card.rect_position = enemy_deck_position

	tween_draw.interpolate_property(
		drawn_card, "rect_position",
		enemy_deck_zone.rect_position, Vector2(enemy_center_hand.x - center_of_cards + cards_in_hand * card_margin - drawn_card.rect_size.x, enemy_center_hand.y),
		0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween_draw.start()
	yield(tween_draw, "tween_all_completed")
