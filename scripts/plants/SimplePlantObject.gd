class_name SimplePlantObject extends PlacedObject

var grew_into_obstacle = false

func _ready():
    pass

# see https://docs.godotengine.org/en/3.0/getting_started/scripting/gdscript/gdscript_basics.html#class-constructor
# for why this is so weird. Basically the thing in () after the . is passing params
# to the original constructor
func _init(position:Vector2).(PlaceableType.PlaceableType.SIMPLE,position):
    pass

func initialize():
    match self.direction_facing:
        Direction.Direction.NORTH:
            next_growth_positions = [position + Vector2(0,-1)]
        Direction.Direction.SOUTH:
            next_growth_positions = [position + Vector2(0,1)]
        Direction.Direction.EAST:
            next_growth_positions = [position + Vector2(1,0)]
        Direction.Direction.WEST:
            next_growth_positions = [position + Vector2(-1,0)]

func execute_grow():
    var temp = next_growth_positions[0]
    match self.direction_facing:
        Direction.Direction.NORTH:
            next_growth_positions = [temp + Vector2(0,-1)]
        Direction.Direction.SOUTH:
            next_growth_positions = [temp + Vector2(0,1)]
        Direction.Direction.EAST:
            next_growth_positions = [temp + Vector2(1,0)]
        Direction.Direction.WEST:
            next_growth_positions = [temp + Vector2(-1,0)]
    
    if not MapManager.can_grow_into(temp):
        self.grew_into_obstacle = true

    return [temp]

func is_dead():
    return self.grew_into_obstacle