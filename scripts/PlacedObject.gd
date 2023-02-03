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

func initialize():
	print("determing what is getting initialized")
	print(seed_type)
	match seed_type:
		PlaceableType.PlaceableType.SIMPLE:
			initialize_simple()

func initialize_simple():
	match direction_facing:
		Direction.Direction.NORTH:
			next_growth_positions = [position + Vector2(0,-1)]
		Direction.Direction.SOUTH:
			next_growth_positions = [position + Vector2(0,1)]
		Direction.Direction.EAST:
			next_growth_positions = [position + Vector2(1,0)]
		Direction.Direction.WEST:
			next_growth_positions = [position + Vector2(-1,0)]

# return the places we would like to place roots 
func execute_grow():
	# delegate to a helper function
	match seed_type:
		PlaceableType.PlaceableType.SIMPLE:
			return execute_grow_simple()

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



