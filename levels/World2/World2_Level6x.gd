extends LevelObject


# Called when the node enters the scene tree for the first time.
func _ready():
	# this has seed store because it inherits LevelObject
	self.seed_store.set_starting_seed_counts({
	PlaceableType.PlaceableType.SIMPLE:4,
	PlaceableType.PlaceableType.STARVING:2,
	PlaceableType.PlaceableType.VINE:0,
	PlaceableType.PlaceableType.CORROSIVE:1,
	PlaceableType.PlaceableType.GREEDY:0,
	PlaceableType.PlaceableType.TUNNELING:0,
	PlaceableType.PlaceableType.ROCK:4,
	})
	
	self.obstacle_tilemap = $ObstacleMap
	self.dirt_tilemap = $DirtMap
	self.required_growth_level = 1
