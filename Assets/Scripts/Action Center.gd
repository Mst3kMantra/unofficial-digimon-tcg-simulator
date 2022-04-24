extends Node

onready var card_view = get_node("Zones/Card View")
onready var phases = get_parent().get_node("Phase Manager")



signal drawn_card
signal unsuspended_cards

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
	rpc("_unsuspend_all")
	

func draw_card():
	var drawn_card = card_view.deck_cards.back()
	card_view.deck_cards.pop_back()
	card_view.hand_cards.append(drawn_card)
	emit_signal("drawn_card")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Phase_Manager_phase_change():
	match phases.phase:
		phases.UNSUSPEND_PHASE:
			unsuspend_all()
		phases.DRAW_PHASE:
			draw_card()
			print("drawing")

remote func _unsuspend_all():
	print("unsuspended")
