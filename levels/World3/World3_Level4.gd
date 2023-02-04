extends LevelObject


# Called when the node enters the scene tree for the first time.
func _ready():
	# this has seed store because it inherits LevelObject
	self.seed_store.set_starting_seed_counts({
	PlaceableType.PlaceableType.SIMPLE:2,
	PlaceableType.PlaceableType.STARVING:0,
	PlaceableType.PlaceableType.VINE:0,
	PlaceableType.PlaceableType.CORROSIVE:0,
	PlaceableType.PlaceableType.GREEDY:0,
	PlaceableType.PlaceableType.TUNNELING:2,
	PlaceableType.PlaceableType.ROCK:0,
	})
	
	self.obstacle_tilemap = $ObstacleMap
	self.dirt_tilemap = $DirtMap
	self.required_growth_level = 6
