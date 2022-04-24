extends Card

var deck = []
onready var card_reader = $CardReader
onready var card_view = get_parent().get_node("Card View")
signal deck_one_loaded

func _ready():
	var new_card = preload("res://Assets/Scenes/Card.tscn")
	card_reader.load_cards()
	var keys = card_reader.deck_dict[0]
	var deck_dicts = card_reader.deck_dict
	var i = 0
	while i < (card_reader.deck_import.size()):
		deck.append(new_card.instance())
		for f in keys:
			deck[i].set(f, (deck_dicts[i])[f])
		i += 1
	emit_signal("deck_one_loaded")


