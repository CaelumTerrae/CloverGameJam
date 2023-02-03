extends Node

enum GameState {MENU, PLANTING, WATERING, LOST, WON}

onready var seed_store = SeedStore.new()
onready var placed_stack = PlacedStack.new()
onready var map_manager = MapManager.new()
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
		place_seed(mouse_tile)
	elif curr_game_state == GameState.WATERING:
		print("beginning growth iteration")
		iterate_growth()

func right_click_handler(mouse_tile):
	if curr_game_state == GameState.PLANTING:
		remove_seed(mouse_tile)



# iterates 1 round of growth
# returns a bool of whether or not the level can continue or should fail
func iterate_growth():
	for i in range(len(placed_stack.stack) - 1, -1, -1):
		# should iterate over all of the placed objects in the stack:
		var curr_placed_object : PlacedObject = placed_stack.stack[i]
		var to_place_arr = curr_placed_object.execute_grow()
	
		for position in to_place_arr:
			print("positions attempting to grow into")
			print(position)
			if not map_manager.can_grow_into(position):
				# ATTEMPTING TO PLACE SOMEWHERE WE CANT! GAME FAILURE
				curr_game_state = GameState.LOST
				print("duuuuude you lost the game! that sucks a ton dude :/")
				return false
			else:
				map_manager.place_root(position)
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
	var newly_placed_object = map_manager.place_object(tile_position, current_object_in_cursor)
	placed_stack.add_placed_object(newly_placed_object)
	print(placed_stack)
		

func remove_seed(tile_position):
	if curr_game_state != GameState.PLANTING:
		return
	# when attempting to remove a seed, update the count
	var current_seed_in_tile_position = map_manager.remove_object(tile_position)

	if current_seed_in_tile_position != PlaceableType.PlaceableType.EMPTY:
		seed_store.give_seed(current_seed_in_tile_position)

	# remove the placement from the stack
	placed_stack.remove_placed_object_at_tile(tile_position)

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
	map_manager.load_level(dirt_tilemap, obstacle_tilemap, seed_tilemap)

func is_placeable_coord(pos: Vector2):
	# we can update the params here if we want to make this more complicated
	return dirt_tilemap.get_cellv(pos) == 10
