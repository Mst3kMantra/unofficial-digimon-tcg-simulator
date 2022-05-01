extends Card

var deck = []
var enemy_deck = []
var baby_deck = []
var enemy_baby = []
var security = []
var enemy_security = []
var temp_deck = []
var temp_enemy_deck
onready var card_reader = $CardReader
var sent_deck = []
signal deck_loaded

func _on_Game_new_match():
	if DefaultDeck.default_deck.empty():
		var file = File.new()
		if file.file_exists("user://saved_decks.dat"):
			file.open("user://saved_decks.dat", File.READ)
			var deck_list = file.get_var()
			var decks = deck_list.keys()
			DefaultDeck.default_deck = deck_list[decks[0]]
			file.close()
	if get_tree().get_network_unique_id() == 1:
		var i = (DefaultDeck.default_deck.size() - 1)
		while i > 0:
			temp_deck.append(DefaultDeck.default_deck[i])
			i -= 1
		temp_deck.shuffle()
		rpc_id(2, "_send_deck", temp_deck)
	else:
		var j = (DefaultDeck.default_deck.size() - 1)
		while j > 0:
			temp_deck.append(DefaultDeck.default_deck[j])
			j -= 1
		temp_deck.shuffle()
		rpc_id(1, "_send_server_deck", temp_deck)

remote func _send_deck(data):
	deck_recieved(data)

remote func _send_server_deck(server_data):
	deck_recieved(server_data)

remote func _send_shuffled_decks(shuffled_deck, sent):
	temp_deck = sent
	sent_deck = shuffled_deck
	rpc_id(1, "_decks_sent")

func deck_recieved(deck_data):
	var player_id = get_tree().get_network_unique_id()
	sent_deck = deck_data
	if player_id == 1:
		temp_deck.shuffle()
		sent_deck.shuffle()
		rpc_id(2, "_send_shuffled_decks", temp_deck, sent_deck)

remote func _decks_sent():
	rpc("_create_decks")

remotesync func _create_decks():
	card_reader.load_cards()
	var new_card = preload("res://Assets/Scenes/Card.tscn")
	var keys = card_reader.deck_dict[0]
	var deck_dicts = card_reader.deck_dict
	var enemy_deck_dicts = card_reader.enemy_deck_dict
	var i = 0
	while i < temp_deck.size():
		deck.append(new_card.instance())
		for f in keys:
			deck[i].set(f, (deck_dicts[i])[f])
		deck[i].set("owner_index", 1)
		i += 1
	var j = 0
	while j < sent_deck.size():
		enemy_deck.append(new_card.instance())
		for k in keys:
			enemy_deck[j].set(k, (enemy_deck_dicts[j])[k])
		enemy_deck[j].set("owner_index", 2)
		j += 1
	emit_signal("deck_loaded")
