extends Node

# this is a list of the levels in the order that they should be played in
var curr_level_index = 0
var level_list = [
	'res://levels/World1/World1_Level1.tscn',
	'res://levels/World1/World1_Level2.tscn',
	'res://levels/World1/World1_Level3.tscn'
]

# increments the curr_level_index and returns the next level
func next_level():
	curr_level_index += 1
	if curr_level_index < len(level_list):
		# valid level to be loaded so 
		# return the next level
		return level_list[curr_level_index]
	return null


