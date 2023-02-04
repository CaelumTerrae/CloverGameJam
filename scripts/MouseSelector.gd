extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_tile = GameManager.seed_tilemap.world_to_map(get_global_mouse_position() /4);	
	var local_pos = GameManager.seed_tilemap.map_to_world(mouse_tile);
	var world_pos = GameManager.seed_tilemap.to_global(local_pos);
	global_position = world_pos
