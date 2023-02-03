extends Node

enum GameState {MENU, PLANTING, WATERING, LOST, WON}

onready var seed_store = SeedStore.new()
onready var current_seed_in_cursor = PlaceableType.PlaceableType.SIMPLE
onready var curr_game_state = GameState.PLANTING
var seed_tilemap : TileMap
var dirt_tilemap : TileMap
var obstacle_tilemap : TileMap

func _ready():
	return

# check whether or not the game has been won.
func is_level_passed():
	# need to check the seed store to see if all seeds have successfully grown!
	pass


# iterates 1 round of growth
# returns a bool of whether or not the level can continue or should fail
func iterate_growth() -> bool:
	# iterate through all seeds and grow them
	return true

func run_water_cycle():
	# shouldn't be able to run this unless the game state is WATERING
	var should_continue = true
	while not is_level_passed() && should_continue:
		should_continue = iterate_growth()
	
	if is_level_passed():
		curr_game_state = GameState.WON
	else:
		curr_game_state = GameState.LOST

func start_watering_cycle():
	# you should only be able to start the watering cycle if you have placed all of your seeds
	if seed_store.all_seed_count() > 0:
		return
	
	# need to update the state of the game to being watering
	curr_game_state = GameState.WATERING
	run_water_cycle()

func place_seed(tile_position):
	# only allow placement if we are in the PLANTING Game state
	if curr_game_state != GameState.PLANTING:
		return
	
	# don't place if not on dirt_map
	if not is_placeable_coord(tile_position):
		return
	
	# don't place operation if we don't have seed
	if not seed_store.has_seed(current_seed_in_cursor):
		return
	
	# always attempt to remove seed first to refund whatever is currently there
	remove_seed(tile_position)
	
	# update the tilemap to place the new seed, and remove it from the store
	seed_tilemap.set_cellv(tile_position, seed_store.get_tile_from_seed_name(current_seed_in_cursor));
	seed_store.use_seed(current_seed_in_cursor)
	print(seed_store.current_seed_counts)
		

func remove_seed(tile_position):
	# when attempting to remove a seed, update the count
	var current_seed_in_tile_position = seed_store.get_seed_name_from_tile(seed_tilemap.get_cellv(tile_position))
	print(current_seed_in_tile_position)
	if current_seed_in_tile_position != PlaceableType.PlaceableType.EMPTY:
		seed_store.give_seed(current_seed_in_tile_position)
	seed_tilemap.set_cellv(tile_position,-1);

# TODO: implement reset_seed_tilemap
func reset_seed_tilemap():
	seed_tilemap.clear()

func load_level(level_node: LevelObject):
	# when a level is loaded the seed_tilemap should be reset
	reset_seed_tilemap()
	
	# the obstacles and dirt from the level should be set via the level
	dirt_tilemap = level_node.get_dirt_tilemap()
	obstacle_tilemap = level_node.get_obstacle_tilemap()
	
	# next the SeedStore should be set to the SeedStore of the level
	seed_store = level_node.get_seed_store()

func is_placeable_coord(pos: Vector2):
	# we can update the params here if we want to make this more complicated
	return dirt_tilemap.get_cellv(pos) == 10
