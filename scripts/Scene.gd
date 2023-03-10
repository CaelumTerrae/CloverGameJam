extends Node2D

onready var TileSet = preload('res://tileset.tres')

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.seed_tilemap = $SeedTileMap;
	MapManager.direction_tilemap = $ForegroundNode/DirectionalityTileMap;
	$GUINode/Control.connect("seed_changed", self, "_on_seed_changed")
	$GUINode/Control.connect("start_watering_state", self, "_start_watering_state")
	GameManager.connect("game_won", self, "_handle_won_game")
	
	# initially load level 1 into the scene by adding it as a child of LevelNode
	load_level("res://levels/World1/World1_Level1.tscn")
	pass

func _handle_won_game():
	# find the next level
	var next_level_resource_path = LevelOrder.next_level()
	load_level(next_level_resource_path)
	print(GameManager.seed_store.current_seed_counts)
	pass

# returns the scaled global position of the mouse.
func get_mouse_position():
	return get_global_mouse_position() / scale;

# returns the tileset that the mouse is hovering over Vec2(x,y)
func get_tileset_position():
	return GameManager.seed_tilemap.world_to_map(get_mouse_position());
	
# input handler!!
func _unhandled_input(event):
	if event is InputEventMouseButton && event.pressed:
		# place something onto the tilemap
		var mouse_tile = get_tileset_position();
		if event.button_index == BUTTON_LEFT:
			GameManager.left_click_handler(mouse_tile)
		elif event.button_index == BUTTON_RIGHT:
			GameManager.right_click_handler(mouse_tile)
			
func load_level(level_resource_path: String):
	# 1. handle logic for loading the scene into the object tree
	# 2. load level specific params into the GameManager
	
	# 1.
	var level_scene = load(level_resource_path)
	# if there is currently a level loaded, unload it from the node.
	if ($LevelNode.get_child_count() != 0):
		for n in $LevelNode.get_children():
			print("removed level currently in LevelNode")
			$LevelNode.remove_child(n)
			n.queue_free()
	# load the next level in
	print("placing new child in level node")
	var level_node = level_scene.instance()
	add_child_below_node($LevelNode, level_node)
	
	# 2.
	GameManager.load_level(level_node)


# Signal resolving functions
func _on_seed_changed(new_seed):
	GameManager.current_object_in_cursor = new_seed
	
	#change cursor to be placeable object sprite
	var atlas = AtlasTexture.new()
	var texture = ImageTexture.new()
	var new_seed_id = MapManager.seed_name_to_tile_map[new_seed]

	texture.create_from_image(TileSet.tile_get_texture(new_seed_id).get_data())
	atlas.atlas = texture
	atlas.region = TileSet.tile_get_region(new_seed_id)
	
	$MouseSelector.set_texture(atlas)
	
	
func _start_watering_state():
	GameManager.start_watering_cycle();


	
