extends CardDatabase

var deck_import = ["Exported from https://digimoncard.io/deckbuilder/","BT1-085","BT1-085","BT1-085","BT4-009","BT4-009","BT4-009","BT4-009","BT4-011","BT4-011","BT4-098","BT4-098","BT4-098","BT4-113","BT4-113","BT4-113","BT4-113","BT6-010","BT6-010","BT6-010","BT6-010","BT7-001","BT7-001","BT7-001","BT7-001","BT7-008","BT7-008","BT7-008","BT7-008","BT7-011","BT7-011","BT7-011","BT7-011","BT7-014","BT7-014","BT7-014","BT7-014","BT7-016","BT7-016","BT7-016","BT7-081","BT7-081","BT7-085","BT7-085","BT7-085","BT7-085","EX1-066","EX1-066","EX1-066","EX1-066","P-029","P-029","P-029","P-029","ST7-12"]
var deck_import_two = ["Exported from https://digimoncard.dev","ST7-01","ST7-01","BT2-001","BT2-001","BT2-001","BT2-009","BT2-009","BT2-009","BT4-115","BT4-115","BT4-115","ST8-06","ST8-06","ST8-06","ST8-06","BT1-060","BT1-060","BT1-060","BT1-060","BT2-020","BT2-020","BT2-039","BT2-039","BT2-039","BT2-039","BT5-112","BT5-112","BT5-112","BT5-112","BT4-096","BT4-096","BT4-096","BT5-093","BT5-093","BT5-093","BT1-107","BT1-107","BT1-107","BT1-107","BT3-098","BT4-100","BT4-100","BT4-100","ST1-16","ST1-16","ST1-16","ST1-16","BT5-095","BT5-095","BT5-095","BT5-095","ST7-12","ST7-12","ST7-12","ST7-12"]
onready var card_reader = get_parent()

var deck_dict = []
var enemy_deck_dict = []
#take exported deck from deck builder website and loop through database to get card_numbers
#use values from imported deck to find index of the matching card in the database
#create new dictionary for imported deck
func load_cards():
	var data_finder
	var card_numbers = []
	for f in card_db:
		card_numbers.append(f.get("card_number"))
	for i in card_reader.temp_deck:
		data_finder = card_numbers.find(i)
		deck_dict.append(card_db[data_finder])
	for k in card_reader.sent_deck:
		data_finder = card_numbers.find(k)
		enemy_deck_dict.append(card_db[data_finder])

