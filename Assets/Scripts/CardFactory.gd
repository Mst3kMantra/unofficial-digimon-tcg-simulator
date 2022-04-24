extends CardDatabase

var deck_import = ["Exported from https://digimoncard.io/deckbuilder/","BT1-085","BT1-085","BT1-085","BT4-009","BT4-009","BT4-009","BT4-009","BT4-011","BT4-011","BT4-098","BT4-098","BT4-098","BT4-113","BT4-113","BT4-113","BT4-113","BT6-010","BT6-010","BT6-010","BT6-010","BT7-001","BT7-001","BT7-001","BT7-001","BT7-008","BT7-008","BT7-008","BT7-008","BT7-011","BT7-011","BT7-011","BT7-011","BT7-014","BT7-014","BT7-014","BT7-014","BT7-016","BT7-016","BT7-016","BT7-081","BT7-081","BT7-085","BT7-085","BT7-085","BT7-085","EX1-066","EX1-066","EX1-066","EX1-066","P-029","P-029","P-029","P-029","ST7-12"]
var deck_dict = []
	
#take exported deck from deck builder website and loop through database to get card_numbers
#use values from imported deck to find index of the matching card in the database
#create new dictionary for imported deck
func load_cards():
	deck_import.pop_front()
	var data_finder
	var card_numbers = []
	for f in card_db:
		card_numbers.append(f.get("card_number"))
	for i in deck_import:
		data_finder = card_numbers.find(i)
		deck_dict.append(card_db[data_finder])

