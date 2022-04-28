extends Card

var deck = []
var enemy_deck = []
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
		rpc_id(2, "_send_deck", DefaultDeck.default_deck)
	else:
		rpc_id(1, "_send_server_deck", DefaultDeck.default_deck)

remote func _send_deck(data):
	deck_recieved(data)

remote func _send_server_deck(server_data):
	deck_recieved(server_data)

func deck_recieved(deck_data):
	sent_deck = deck_data
	card_reader.load_cards()
	var new_card = preload("res://Assets/Scenes/Card.tscn")
	var keys = card_reader.deck_dict[0]
	var deck_dicts = card_reader.deck_dict
	var enemy_deck_dicts = card_reader.enemy_deck_dict
	var i = 0
	while i < (DefaultDeck.default_deck.size()):
		deck.append(new_card.instance())
		for f in keys:
			deck[i].set(f, (deck_dicts[i])[f])
		i += 1
	var j = 0
	while j < (sent_deck.size()):
		enemy_deck.append(new_card.instance())
		for k in keys:
			enemy_deck[j].set(k, (enemy_deck_dicts[j])[k])
		j += 1
	print(enemy_deck.size())
	emit_signal("deck_loaded")
