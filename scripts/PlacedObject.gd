class_name PlacedObject extends Node

# DESCRIPTION:
# PlacedObjects keeps track of the metadata of placed objects
# like seeds or rocks in the world.

var seed_type
var position : Vector2
var direction_facing = Direction.Direction.EAST
var next_growth_positions = []


# Called when the node enters the scene tree forsthe first time.
func _ready():
	pass

func _init(seed_type_param, position_param):
	seed_type = seed_type_param
	position = position_param
	initialize()

func rotate_orientation():
	match direction_facing:
		Direction.Direction.NORTH:
			direction_facing = Direction.Direction.EAST
		Direction.Direction.WEST:
			direction_facing = Direction.Direction.NORTH
		Direction.Direction.SOUTH:
			direction_facing = Direction.Direction.WEST
		Direction.Direction.EAST:
			direction_facing = Direction.Direction.SOUTH

func get_position() -> Vector2:
	return position

func set_position(new_position):
	position = new_position

func is_dead():
	return false

# should determine the first next_growth_positions of the plant
func initialize():
	# this is intentionally a stub and should be overwritten by the specific plant object
	print("called initialize on PlacedObject instead of specific PlantObject (e.g. SimplePlantObject")

# returns the places that the plant would like to grow, and
# updates next_growth_positions
func execute_grow():
	# this is intentionally a stub and should be overwritten by the specific plant object
	print("called execute_grow on PlacedObject instead of specific PlantObject (e.g. SimplePlantObject")

func execute_grow_simple():
	var temp = next_growth_positions[0]
	match direction_facing:
		Direction.Direction.NORTH:
			next_growth_positions = [temp + Vector2(0,-1)]
		Direction.Direction.SOUTH:
			next_growth_positions = [temp + Vector2(0,1)]
		Direction.Direction.EAST:
			next_growth_positions = [temp + Vector2(1,0)]
		Direction.Direction.WEST:
			next_growth_positions = [temp + Vector2(-1,0)]
	return [temp]
