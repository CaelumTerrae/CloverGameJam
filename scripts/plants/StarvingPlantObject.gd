class_name StarvingPlantObject extends PlacedObject

var grew_into_obstacle = false

func _ready():
    pass

# see https://docs.godotengine.org/en/3.0/getting_started/scripting/gdscript/gdscript_basics.html#class-constructor
# for why this is so weird. Basically the thing in () after the . is passing params
# to the original constructor
func _init(position:Vector2).(PlaceableType.PlaceableType.STARVING,position):
    pass

func initialize():
	next_growth_positions = []

func execute_grow():
	return []

func is_dead():
	# generates 3x3 square surrounding pos, and excludes check for pos
	for i in range(-1,2):
		for j in range (-1,2):
			if i == 0 && j == 0:
				break
			else:
				if MapManager.is_plant_matter(position + Vector2(i,j)):
					print("lost because of starving plant")
					print(Vector2(i,j))
					return true
	return false