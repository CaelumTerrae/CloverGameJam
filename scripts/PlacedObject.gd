class_name PlacedObject extends Node

# DESCRIPTION:
# PlacedObjects keeps track of the metadata of placed objects
# like seeds or rocks in the world.

var seed_type
var position : Vector2
var direction_facing = Direction.Direction.EAST


# Called when the node enters the scene tree forsthe first time.
func _ready():
	pass

func _init(seed_type_param, position_param):
	seed_type = seed_type_param
	position = position_param

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
