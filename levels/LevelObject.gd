class_name LevelObject extends Node2D

# initialize each level with some seedstore
var seed_store: SeedStore=SeedStore.new()
var dirt_tilemap: TileMap
var obstacle_tilemap: TileMap
var required_growth_level: int
 
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_dirt_tilemap() -> TileMap:
	return dirt_tilemap
	
func get_obstacle_tilemap() -> TileMap:
	return obstacle_tilemap

func get_seed_store() -> SeedStore:
	return seed_store

func get_required_growth_level() -> int:
	return required_growth_level
