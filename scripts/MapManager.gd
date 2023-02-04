extends Node

# DESCRIPTION:
# THIS IS A SINGLETON CLASS. IT CAN BE ACCESSED ANYWHERE IN THE SCRIPT
# SO YOU DONT HAVE TO PASS BACK A REFERENCE TO THE MANAGER
# This is the interface between the abstract representation of what should
# be placed on different tilemap layers, and what will be stored in the 
# abstract representation used to deal with game state.

# This will give us the ability to simplify logic, and also add skins for
# different levels or whatnot

# an offset to map the placeable array to the tileset and viceversa
# E.g. (2,3) would mean the top left of the placeable array is at 2,3
# in the tilemap!
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

# temporarily the thing we will use for the root_tile
var root_tile_num = 4;

var offset : Vector2;
var dirt_tilemap : TileMap;
var obstacle_tilemap : TileMap;
var seed_tilemap : TileMap;
var direction_tilemap: TileMap;

# have some TILE_STATEs that you can use to distinguish which you can
# delete w/ corrosive vs. which are permanent obstacles
var representation_array : Array;

enum TILE_STATES {
	UNOCCUPIED, # free spaces
	PLANT_OCCUPIED, # occupied by a plant
	ROOT_OCCUPIED, # occupied by a root grown by a plant
	PLACED_ROCK, # occupied by a rock
	OCCUPIED_UNCHANGEABLE, # spaces that are occupied but cannot be overwritten
}

# Called when the node enters the scene tree for the first time.
func _ready():
	return

func _init():
	return

func load_level(dirt_tm: TileMap, obstacle_tm: TileMap, seed_tm: TileMap):
	if dirt_tilemap != null:
		dirt_tilemap.clear()
	clear_representation_array()
	dirt_tilemap = dirt_tm
	obstacle_tilemap = obstacle_tm
	seed_tilemap = seed_tm
	direction_tilemap.clear()
	representation_array = generate_representation_array()
	# load in obstacles to the representation array using the obstacle tilemap.
	print_representation_array()

# this is a very large function that will take all available
# information across the game state and use it to render out the display!
# it should only really have to make updates to the seed_tilemap
func render_to_display():
	# clear before re-displaying
	if seed_tilemap != null:
		seed_tilemap.clear()
	if direction_tilemap != null:
		direction_tilemap.clear()

	# iterate over the plant stack in order to determine which placed_objects to render on the screen layer
	var placed_stack = GameManager.placed_stack.stack
	for placed_object in placed_stack:
		var tilemap_pos : Vector2 = rep_pos_to_tilemap_pos(placed_object.get_position())
		var object_type_name = placed_object.get_object_type()
		seed_tilemap.set_cellv(tilemap_pos, get_tile_from_seed_name(object_type_name))
		direction_tilemap.set_cellv(tilemap_pos, get_tile_from_direction_enum(placed_object.get_direction()))
	
	# iterate over the rep_array to place roots and other thingies:
	for x in range(len(representation_array)):
		for y in range(len(representation_array[0])):
			var rep_pos = Vector2(x,y)
			if get_in_rep_array(rep_pos) == TILE_STATES.ROOT_OCCUPIED:
				# place root on tilemap by placing correct tile in visual representation
				seed_tilemap.set_cellv(rep_pos_to_tilemap_pos(rep_pos), root_tile_num)
	pass



# this will generate the representation array (uninitialized)
func generate_representation_array():
	var min_x = 100000
	var max_x = -1
	var min_y = 100000
	var max_y = -1

	for i in range(0,50):
		for j in range(0,50):
			if is_placeable_coord_from_tilemap(Vector2(i,j)):
				min_x = min(i, min_x)
				max_x = max(i, max_x)
				min_y = min(j, min_y)
				max_y = max(j, max_y)
	
	offset = Vector2(min_x, min_y)

	# some error caused values to never change from initialization
	# return an empty 2d array
	if min_x == 100000 || max_x == -1 || min_y == 100000 || max_y == -1:
		return [[]]
	
	var uninitialized_array = generate_x_by_y_matrix(max_x - min_x + 1, max_y - min_y + 1)
	
	print_array_to_std_out(uninitialized_array)

	for i in range(len(uninitialized_array)):
		for j in range(len(uninitialized_array[0])):
			uninitialized_array[i][j] = TILE_STATES.UNOCCUPIED if is_placeable_coord_from_tilemap(offset + Vector2(i,j)) else TILE_STATES.OCCUPIED_UNCHANGEABLE

	return uninitialized_array

func print_representation_array():
	print_array_to_std_out(representation_array)
		
func print_array_to_std_out(array):
	# the native way of printing a 2d array will print it with first
	# coord being the y and the second coord being the x
	# so to make this easier, I'm gonna flip the printing!
	if len(array) > 0 && len(array[0]) > 0:
		for y in range(len(array[0])):
			var temp_str = '';
			for x in range(len(array)):
				temp_str += String(array[x][y])
			print(temp_str)

# this is for generating whether or not the tile is placeable
# position here refers to a position on the TileMap
func is_placeable_coord_from_tilemap(pos: Vector2):
	# this logic can get more complicated as there are further levels
	return dirt_tilemap.get_cellv(pos) == 10

func generate_x_by_y_matrix(width: int, height: int):
	var matrix = []
	for i in range(width):
		matrix.append([])
		for j in range(height):
			matrix[i].append(TILE_STATES.UNOCCUPIED)
	return matrix

func get_in_rep_array(pos:Vector2):
	return representation_array[pos.x][pos.y]

func set_in_rep_array(pos:Vector2, new_val):
	print(len(representation_array))
	print(len(representation_array[pos.x]))
	representation_array[pos.x][pos.y] = new_val
	print_representation_array()

func tilemap_pos_to_rep_pos(tile_map_pos: Vector2):
	return tile_map_pos - offset

func rep_pos_to_tilemap_pos(rep_pos: Vector2):
	return rep_pos + offset

func place_root(rep_pos):
	# place root in rep array
	set_in_rep_array(rep_pos, TILE_STATES.ROOT_OCCUPIED);
	render_to_display()


func place_object(pos_from_tilemap, current_object_in_cursor):
	# place seed in representation array
	var representation_position = tilemap_pos_to_rep_pos(pos_from_tilemap)
	if object_is_plant(current_object_in_cursor):
		set_in_rep_array(representation_position, TILE_STATES.PLANT_OCCUPIED)
	else:
		set_in_rep_array(representation_position, TILE_STATES.PLACED_ROCK)
	render_to_display()


func object_is_plant(placeable_object_type):
	match placeable_object_type:
		PlaceableType.PlaceableType.EMPTY:
			return false
		PlaceableType.PlaceableType.ROCK:
			return false
		_:
			return true

# removes object and returns whatever was formerly there
func remove_object(pos_from_tilemap):
	# set position in rep_array to unoccupied
	var representation_position = tilemap_pos_to_rep_pos(pos_from_tilemap)
	set_in_rep_array(representation_position, TILE_STATES.UNOCCUPIED)
	render_to_display()

func get_tile_from_seed_name(seed_type):
	return seed_name_to_tile_map[seed_type]

func get_seed_name_from_tile(tile):
	return tile_map_to_seed_name[tile]

# helper function to determine whether or not a position is in bounds of the
# representation map
# this should take a representation_position
func in_representation_bounds(pos: Vector2):
	return pos.x >= 0 && pos.y >=0 && pos.x < len(representation_array) && pos.y < len(representation_array[0])

func can_overwrite_in_rep_array(pos_from_tilemap):
	# check whether or not the position is even
	# in the bounds of the representation map 
	# (interactable area)
	var rep_pos = tilemap_pos_to_rep_pos(pos_from_tilemap)
	if not in_representation_bounds(rep_pos):
		return false
	var tile_state = get_in_rep_array(rep_pos)
	return tile_state == TILE_STATES.UNOCCUPIED || tile_state == TILE_STATES.PLACED_ROCK || tile_state == TILE_STATES.PLANT_OCCUPIED

func can_grow_into(rep_pos):
	if not in_representation_bounds(rep_pos):
		return false
	var state_in_rep_pos = get_in_rep_array(rep_pos)
	return state_in_rep_pos == TILE_STATES.UNOCCUPIED

func is_plant_matter(rep_pos):
	if not in_representation_bounds(rep_pos):
		return false
	
	var tile_state = get_in_rep_array(rep_pos)
	if tile_state == TILE_STATES.PLANT_OCCUPIED || tile_state == TILE_STATES.ROOT_OCCUPIED:
		return true
	return false

var direction_to_tile_mapping = {
	Direction.Direction.NORTH : 27,
	Direction.Direction.WEST : 26,
	Direction.Direction.EAST : 25,
	Direction.Direction.SOUTH : 28,
}

func get_tile_from_direction_enum(direction):
	return direction_to_tile_mapping[direction]

func clear_representation_array():
	for i in range(len(representation_array)):
		for j in range(len(representation_array[0])):
			var rep_pos = Vector2(i,j)
			var curr_tile = get_in_rep_array(rep_pos)
			match curr_tile:
				TILE_STATES.UNOCCUPIED:
					# do nothing
					continue
				TILE_STATES.PLANT_OCCUPIED:
					# update the plant space to be unoccupied
					set_in_rep_array(rep_pos, TILE_STATES.UNOCCUPIED)
				TILE_STATES.ROOT_OCCUPIED:
					set_in_rep_array(rep_pos, TILE_STATES.UNOCCUPIED)
				TILE_STATES.PLACED_ROCK:
					set_in_rep_array(rep_pos, TILE_STATES.CHANGEABLE)
	render_to_display()


func reset_map():
	# return the state to the level when it is initially loaded!
	clear_representation_array()
	pass
