class_name MapManager extends Node

# DESCRIPTION:
# This is the interface between the abstract representation of what should
# be placed on different tilemap layers, and what will be stored in the 
# abstract representation used to deal with game state.

# Eseentially, we want to decouple the tile_map used for rendering tile
# sprites and the notion of obstacles. 

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

var offset : Vector2;
var dirt_tilemap : TileMap;
var obstacle_tilemap : TileMap;
var seed_tilemap : TileMap;

var representation_array : Array;

enum TILE_STATES {
	UNOCCUPIED, # free spaces
	OCCUPIED_CHANGEABLE, # spaces that are occupied but can be overwritten
	OCCUPIED_UNCHANGEABLE, # spaces that are occupied but cannot be overwritten
}

# Called when the node enters the scene tree for the first time.
func _ready():
	return

func _init():
	return

func load_level(dirt_tm: TileMap, obstacle_tm: TileMap, seed_tm: TileMap):
	dirt_tilemap = dirt_tm
	obstacle_tilemap = obstacle_tm
	seed_tilemap = seed_tm
	representation_array = generate_representation_array()
	print_representation_array()


# this will generate the representation array (uninitialized)
func generate_representation_array():
	var min_x = 100000
	var max_x = -1
	var min_y = 100000
	var max_y = -1

	for i in range(0,50):
		for j in range(0,50):
			if is_placeable_coord(Vector2(i,j)):
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

	for i in range(len(uninitialized_array)):
		for j in range(len(uninitialized_array)):
			uninitialized_array[i][j] = TILE_STATES.UNOCCUPIED if is_placeable_coord(offset + Vector2(i,j)) else TILE_STATES.OCCUPIED_UNCHANGEABLE

	return uninitialized_array

func print_representation_array():
	# the native way of printing a 2d array will print it with first
	# coord being the y and the second coord being the x
	# so to make this easier, I'm gonna flip the printing!
	if len(representation_array) > 0 && len(representation_array[0]) > 0:
		for y in range(len(representation_array[0])):
			var temp_str = '';
			for x in range(len(representation_array)):
				temp_str += String(representation_array[x][y])
			print(temp_str)

# this is for generating whether or not the tile is placeable
# position here refers to a position on the TileMap
func is_placeable_coord(pos: Vector2):
	# this logic can get more complicated as there are further levels
	return dirt_tilemap.get_cellv(pos) == 10

func generate_x_by_y_matrix(width: int, height: int):
	var matrix = []
	for i in range(width):
		matrix.append([])
		for j in range(height):
			matrix[i].append(TILE_STATES.UNOCCUPIED)
	return matrix

func set_in_rep_array(pos:Vector2, new_val):
	representation_array[pos.x][pos.y] = new_val
	print_representation_array()

func tilemap_pos_to_rep_pos(tile_map_pos: Vector2):
	return tile_map_pos - offset

func place_object(pos_from_tilemap, current_object_in_cursor):
	# place seed in tilemap by placing correct tile in visual representation
	seed_tilemap.set_cellv(pos_from_tilemap, get_tile_from_seed_name(current_object_in_cursor))

	# place seed in representation array
	var representation_position = tilemap_pos_to_rep_pos(pos_from_tilemap)
	set_in_rep_array(representation_position, TILE_STATES.OCCUPIED_CHANGEABLE)

	# create newly placed object
	return PlacedObject.new(current_object_in_cursor, representation_position)

func remove_object(pos_from_tilemap):
	# remove the object from the visual representation
	seed_tilemap.set_cellv(pos_from_tilemap, -1)

	var representation_position = tilemap_pos_to_rep_pos(pos_from_tilemap)
	set_in_rep_array(representation_position, TILE_STATES.UNOCCUPIED)



func get_tile_from_seed_name(seed_type):
	return seed_name_to_tile_map[seed_type]

func get_seed_name_from_tile(tile):
	return tile_map_to_seed_name[tile]
