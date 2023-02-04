extends Node
signal level_complete()

# DESCRIPTION:
# THIS IS A SINGLETON CLASS. IT CAN BE ACCESSED ANYWHERE IN THE SCRIPT
# SO YOU DONT HAVE TO PASS BACK A REFERENCE TO THE MANAGER 
# This is the main housing of all of the game state logic. In other
# words, it interfaces between different pieces of local logic
# like how we keep track of seeds, and the map, in order to 
# generate the overall game logic!

enum GameState {MENU, PLANTING, WATERING, LOST, WON}

onready var seed_store = SeedStore.new()
onready var placed_stack = PlacedStack.new()
onready var current_object_in_cursor = PlaceableType.PlaceableType.SIMPLE
onready var curr_game_state = GameState.PLANTING
var curr_growth_level = 0
var seed_tilemap : TileMap
var dirt_tilemap : TileMap
var required_growth_level
var obstacle_tilemap : TileMap

# the seed stack is a queue that holds SeedObjects

func _ready():
	return

# check whether or not the game has been won.
func is_level_passed():
	return curr_growth_level >= required_growth_level


func left_click_handler(mouse_tile):
	if curr_game_state == GameState.PLANTING:
		if current_object_in_cursor == PlaceableType.PlaceableType.EMPTY:
			remove_seed(mouse_tile)
		else:
			place_seed(mouse_tile)
	elif curr_game_state == GameState.WATERING:
		print("beginning growth iteration")

func right_click_handler(mouse_tile):
	if curr_game_state == GameState.PLANTING:
		rotate_object(mouse_tile)

# iterates over plants to see if any have died
func any_plants_dead():
	for plant in placed_stack.stack:
		if plant.is_dead():
			return true
	return false

# iterates 1 round of growth
# returns a bool of whether or not the level can continue or should fail
func iterate_growth() -> bool:
	for i in range(len(placed_stack.stack) - 1, -1, -1):
		# should iterate over all of the placed objects in the stack:
		var curr_placed_object : PlacedObject = placed_stack.stack[i]
		
		# get the places that the object would like to grow into
		var to_place_arr = curr_placed_object.execute_grow()

		# determine if the growth stage kills any plants
		# before placing their objects on the map
		# to avoid weird glitches
		if any_plants_dead():
			curr_game_state = GameState.LOST
			print("duuuuude you lost the game! that sucks a ton!")
			return false
		
		# if growth stage doesn't kill any plants
		for position in to_place_arr:
				MapManager.place_root(position)

		# check if map updates killed plants
		# (new roots can kill starving plants or whatever)
		if any_plants_dead():
			curr_game_state = GameState.LOST
			print("duuuuude you lost the game! that sucks a ton!")
			return false
	print("made it through one iteration cycle")
	curr_growth_level += 1
	return true


func run_water_cycle():
	# shouldn't be able to run this unless the game state is WATERING
	if curr_game_state != GameState.WATERING:
		return
	# keep track of whether or not there was a failure at any point during the level
	var should_continue = true
	while not is_level_passed() && should_continue:
		should_continue = iterate_growth()
	
	if is_level_passed():
		curr_game_state = GameState.WON
		# load next level
		emit_signal("level_complete")
		print("you won this level! :D")
	else:
		print("you lost this level! D:")
		curr_game_state = GameState.LOST

func start_watering_cycle():
	# you should only be able to start the watering cycle if you have placed all of your seeds
	if seed_store.all_seed_count() > 0:
		return
	
	print("what about this?")
	# need to update the state of the game to being watering
	curr_game_state = GameState.WATERING
	print(curr_game_state)
	run_water_cycle()

func rotate_object(tile_position):
	if curr_game_state != GameState.PLANTING:
		return
	var rep_position = MapManager.tilemap_pos_to_rep_pos(tile_position)
	var placed_object = placed_stack.get_placed_object_at_tile(rep_position)
	if placed_object != null:
		print("old direction", placed_object.get_direction())
		placed_object.rotate_orientation()
		print("new direction", placed_object.get_direction())
	# manually let the map manager know to update the map
	MapManager.render_to_display()
	

func place_seed(tile_position):
	if curr_game_state != GameState.PLANTING:
		return
	
	# don't place if not on dirt_map
	# this should use the abstract representation to see if there is an obstacle there?
	if not is_placeable_coord(tile_position):
		return
	
	# don't place operation if we don't have seed
	if not seed_store.has_seed(current_object_in_cursor):
		return
	
	# always attempt to remove seed currently in the position to refund whatever is currently there
	remove_seed(tile_position)
	
	# let the store know we are using a seed
	seed_store.use_seed(current_object_in_cursor)
	
	# use the map manager to place the seed both in abstract
	# representation, and in tilemap simultaneously
	var representation_position = MapManager.tilemap_pos_to_rep_pos(tile_position)
	var new_placed_object = GameManager.construct_placed_object_from_seed_type(current_object_in_cursor, representation_position)
	placed_stack.add_placed_object(new_placed_object)
	print(placed_stack)
	MapManager.place_object(tile_position, current_object_in_cursor)
	
		

func remove_seed(tile_position):
	if curr_game_state != GameState.PLANTING:
		return
	
	# remove any object that might've been at the tile from the stack
	var rep_position = MapManager.tilemap_pos_to_rep_pos(tile_position)
	var current_object_type_in_tile_position = placed_stack.remove_placed_object_at_tile(rep_position)

	# remove the object from the map
	MapManager.remove_object(tile_position)

	# update the count in the seed store
	if current_object_type_in_tile_position != null:
		seed_store.give_seed(current_object_type_in_tile_position)

func reset_seed_tilemap():
	seed_tilemap.clear()

func load_level(level_node: LevelObject):
	# when a level is loaded the seed_tilemap should be reset
	reset_seed_tilemap()

	# reset the curr_growth level
	curr_growth_level = 0
	
	# the obstacles and dirt from the level should be set via the level
	dirt_tilemap = level_node.get_dirt_tilemap()
	obstacle_tilemap = level_node.get_obstacle_tilemap()
	required_growth_level = level_node.get_required_growth_level()
	
	# next the SeedStore should be set to the SeedStore of the level
	seed_store = level_node.get_seed_store()

	# pass the tilemaps to the map manager
	MapManager.load_level(dirt_tilemap, obstacle_tilemap, seed_tilemap)

func is_placeable_coord(pos: Vector2):
	# we can update the params here if we want to make this more complicated
	return dirt_tilemap.get_cellv(pos) == 10

func construct_placed_object_from_seed_type(seed_type, representation_position):
	match seed_type:
		PlaceableType.PlaceableType.SIMPLE:
			return SimplePlantObject.new(representation_position)
		PlaceableType.PlaceableType.STARVING:
			return StarvingPlantObject.new(representation_position)
	
	return PlacedObject.new(seed_type, representation_position)
