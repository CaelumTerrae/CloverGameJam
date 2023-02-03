class_name SeedStore extends Node

# DESCRIPTION:
# Seed Store keeps track of the number of seeds available in a given level
# as well as the current positions of seeds.

var current_seed_counts = {
	PlaceableType.PlaceableType.SIMPLE:5,
	PlaceableType.PlaceableType.STARVING:5,
	PlaceableType.PlaceableType.VINE:5,
	PlaceableType.PlaceableType.CORROSIVE:5,
	PlaceableType.PlaceableType.GREEDY:5,
	PlaceableType.PlaceableType.TUNNELING:5,
}

func _ready():
	pass # Replace with function body.

func _init(seed_counts_dict:={}):
	set_starting_seed_counts(seed_counts_dict)
	return

# this should only ever get called once at the beginning of initialization or when a level is
# started
func set_starting_seed_counts(seed_counts_dict:={}):
	for key in seed_counts_dict:
		current_seed_counts[key] = seed_counts_dict[key]
	return

func has_seed(seed_type):
	return current_seed_counts[seed_type] > 0
	
func use_seed(seed_type):
	current_seed_counts[seed_type] -= 1
	
func give_seed(seed_type):
	current_seed_counts[seed_type] += 1

func all_seed_count():
	var counter = 0
	for key in current_seed_counts:
		counter += current_seed_counts[key]
	return counter
