extends Node2D

var level_paths = [
	"res://levels/World1/World1_Level1.tscn",
	"res://levels/World1/World1_Level2.tscn",
	"res://levels/World1/World1_Level3.tscn",
	"res://levels/World1/World1_Level3x.tscn",
	"res://levels/World1/World1_Level4.tscn",
	"res://levels/World1/World1_Level4x.tscn",
	"res://levels/World1/World1_Level5.tscn",
	"res://levels/World1/World1_Level5x.tscn",
	"res://levels/World1/World1_Level6.tscn",
	"res://levels/World1/World2_Level1.tscn",
	"res://levels/World1/World2_Level2.tscn",
	"res://levels/World1/World2_Level3.tscn",
	"res://levels/World1/World2_Level4.tscn",
	"res://levels/World1/World2_Level5.tscn",
	"res://levels/World1/World2_Level5x.tscn",
	"res://levels/World1/World2_Level6.tscn",
	"res://levels/World1/World2_Level6x.tscn",
	"res://levels/World1/World3_Level1.tscn",
	"res://levels/World1/World3_Level1x.tscn",
	"res://levels/World1/World3_Level2.tscn",
	"res://levels/World1/World3_Level3.tscn",
	"res://levels/World1/World3_Level4.tscn",
];
# 0 indexed level
var cur_level : int


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.seed_tilemap = $SeedTileMap;
	MapManager.direction_tilemap = $ForegroundNode/DirectionalityTileMap;
	$GUINode/Control.connect("seed_changed", self, "_on_seed_changed")
	$GUINode/Control.connect("start_watering_state", self, "_start_watering_state")
	GameManager.connect("level_complete", self, "_handle_level_complete")
	
	# initially load level 1 into the scene by adding it as a child of LevelNode
	cur_level = 0
	load_level(level_paths[cur_level])
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

func _handle_level_complete():
	cur_level += 1
	load_level(level_paths[cur_level])
	pass
