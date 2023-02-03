extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.seed_tilemap = $SeedTileMap;
	$GUINode/Control.connect("seed_changed", self, "_on_seed_changed")
	$GUINode/Control.connect("start_watering_state", self, "_start_watering_state")
	
	
	# initially load level 1 into the scene by adding it as a child of LevelNode
	load_level("res://levels/World1_Level1.tscn")
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
			GameManager.place_seed(mouse_tile)
		elif event.button_index == BUTTON_RIGHT:
			GameManager.remove_seed(mouse_tile)
			
func load_level(level_resource_path: String):
	# 1. handle logic for loading the scene into the object tree
	# 2. load level specific params into the GameManager
	
	# 1.
	var level_scene = load(level_resource_path)
	# if there is currently a level loaded, unload it from the node.
	if ($LevelNode.get_child_count() != 0):
		for n in $LevelNode.get_children():
			$LevelNode.remove_child(n)
			n.queue_free()
	# load the next level in
	var level_node = level_scene.instance()
	add_child_below_node($LevelNode, level_node)
	
	# 2.
	GameManager.load_level(level_node)


# Signal resolving functions
func _on_seed_changed(new_seed):
	GameManager.current_object_in_cursor = new_seed

func _start_watering_state():
	GameManager.start_watering_cycle();


	
