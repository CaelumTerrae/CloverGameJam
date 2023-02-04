class_name PlacedStack extends Node

# DESCRIPTION:
# The PlacedStack is a stack implementation that the GameManager will use to keep track of
# PlacedObjects 

# It is the definitive interface for dealing with objects on the map that have been placed

var stack : Array = [] 

func _ready():
	pass # Replace with function body.


func add_placed_object(placed_object : PlacedObject):
	stack.append(placed_object)

# remove the object at a given tile position while preserving the rest of the 
# placement order
# returns the type of the placed object
func remove_placed_object_at_tile(position: Vector2):
	var index = 0
	while index < len(stack):
		var placed_object : PlacedObject = stack[index]
		if placed_object.get_position() == position:
			break
		index += 1
	# we found an object with the position
	if index < len(stack):
		var placed_object : PlacedObject = stack.pop_at(index)
		return placed_object.get_object_type()
	return null

# returns reference to an object at a given position in the tile
# if there is no such object, return null
func get_placed_object_at_tile(position: Vector2):
	var index = 0
	while index < len(stack):
		var placed_object : PlacedObject = stack[index]
		if placed_object.get_position() == position:
			return placed_object
		index += 1
	return null

func reset_stack():
	stack = []

	