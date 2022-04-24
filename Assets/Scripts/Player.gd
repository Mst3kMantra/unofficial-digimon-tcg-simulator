extends Node


const max_deck = 45
const max_baby = 5

var index
const max_memory = 10

var spent
var current_memory
var start_memory
var end_memory
var next_turn_memory

	

func next_turn_memory_set():
	return end_memory * -1
	

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





# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
