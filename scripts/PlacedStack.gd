class_name PlacedStack extends Node

# DESCRIPTION:
# The PlacedStack is a stack implementation that the GameManager will use to keep track of
# PlacedObjects 

# It is the definitive interface for dealing with objects on the map that have been placed

var stack = []

func _ready():
	pass # Replace with function body.


func add_placed_object(placed_object : PlacedObject):
	stack.append(placed_object)

# remove the object at a given tile position while preserving the rest of the 
# placement order
func remove_placed_object_at_tile(position: Vector2):
	var index = 0
	while index < len(stack):
		var placed_object : PlacedObject = stack[index]
		if placed_object.get_position() == position:
			break
		index += 1
	# we found an object with the position
	if index < len(stack):
		stack.pop_at(index)

	