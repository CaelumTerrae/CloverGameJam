class_name SeedStore extends Node
var seed_name_to_tile_map = {
	PlaceableType.PlaceableType.EMPTY: -1,
	PlaceableType.PlaceableType.SIMPLE:9,
	PlaceableType.PlaceableType.STARVING:11,
	PlaceableType.PlaceableType.VINE:12,
	PlaceableType.PlaceableType.CORROSIVE:13,
	PlaceableType.PlaceableType.GREEDY:14,
	PlaceableType.PlaceableType.TUNNELING:15,
}

var tile_map_to_seed_name = {
	-1 : PlaceableType.PlaceableType.EMPTY,
	9  :PlaceableType.PlaceableType.SIMPLE,
	11 :PlaceableType.PlaceableType.STARVING,
	12 :PlaceableType.PlaceableType.VINE,
	13 :PlaceableType.PlaceableType.CORROSIVE,
	14 :PlaceableType.PlaceableType.GREEDY,
	15 :PlaceableType.PlaceableType.TUNNELING,
}

var current_seed_counts = {
	PlaceableType.PlaceableType.SIMPLE:5,
	PlaceableType.PlaceableType.STARVING:5,
	PlaceableType.PlaceableType.VINE:5,
	PlaceableType.PlaceableType.CORROSIVE:5,
	PlaceableType.PlaceableType.GREEDY:5,
	PlaceableType.PlaceableType.TUNNELING:5,
}
var seed_stack = []

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
	

# gdscript doesn't support enum typing lol
func get_tile_from_seed_name(seed_type):
	return seed_name_to_tile_map[seed_type]

func get_seed_name_from_tile(tile):
	return tile_map_to_seed_name[tile]

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