extends Node2D



var hand_cards = []
onready var deck_loader = get_parent().get_node("Deck Loader")
onready var deck_zone = $Deck
var deck_cards = []
var trash_cards = []
var baby_deck = []
var breeding_cards = []
var security_cards = []
var card_art_string_format = "res://Resources/Sprites/%s.jpg"
var start_pos = []
var start_pos_y = []
var shifted_pos_left = []
var shifted_pos_right = []
var card_check

signal card_changed


onready var center_hand = get_viewport_rect().size/2 + Vector2(card_offset.x/1.5 + 1200,0) + Vector2(0,card_offset.y * 1.5)
onready var mouse_check = false

var card_offset = Vector2(300,800)
var card_margin = card_offset.x/1.1

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
# warning-ignore:return_value_discarded
	self.connect("card_changed", self, "_on_card_change")


func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	var result = space_state.intersect_ray(mouse_position, mouse_position, [], 2147483647, true, true)
	var count = hand_cards.size()
	if result.size() == 0 && hand_cards.empty() == false && start_pos.empty() == false && start_pos_y.empty() == false:
		emit_signal("card_changed")
	if result.size() != 0 && mouse_position.y > 780 && mouse_position.y < 1300:
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
			pass
		if tween_move_left.is_active() == true:
			pass
		if tween_move_right.is_active() == true:
			pass
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



func _on_Deck_Loader_deck_one_loaded():
	deck_cards = deck_loader.deck
	var i = 0
	while i < (deck_cards.size()):
		var type = deck_cards[i].type
		if type == "Digi-Egg":
			baby_deck.append(deck_cards.pop_at(i))
			i = 0
		i += 1
	deck_cards.shuffle()

func _on_card_change():
	var count = hand_cards.size()
	for j in count:
		var card = hand_cards[j]
		var tween_shrink = card.get_node("Shrink")
		var tween_move_back = card.get_node("Move Back")
		var tween_draw = card.get_node("Draw")
		var area = card.get_node("Area2D")
		if tween_shrink.is_active() == true:
			break
		if tween_draw.is_active() == true:
			break
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
			break
		if count != start_pos.size():
			break
		if tween_move_back.is_active() == true:
			tween_move_back.reset_all()
		tween_move_back.interpolate_property(
			card, "rect_position",
			card.rect_position, Vector2(start_pos[j], start_pos_y[j]),
			.1, Tween.TRANS_QUINT)
		tween_move_back.start()
	

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
	self.add_child(drawn_card)
	drawn_card.rect_position = deck_position
	
	tween_draw.connect("tween_completed", self, "_on_draw_completed")
	
	tween_draw.interpolate_property(
		drawn_card, "rect_position", 
		deck_zone.rect_position, Vector2(center_hand.x - center_of_cards + cards_in_hand * card_margin - drawn_card.rect_size.x/1.5, center_hand.y), 
		0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween_draw.start()

func _on_draw_completed(_object, _key):
	get_start_pos()


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
