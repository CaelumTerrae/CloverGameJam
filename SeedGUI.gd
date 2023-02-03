extends Control
signal seed_changed(new_seed)
signal start_watering_state()


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/FirstRowContainer/Seed1Button.connect("pressed",self, "_pressed_button_1");
	$VBoxContainer/FirstRowContainer/Seed2Button.connect("pressed",self, "_pressed_button_2");
	$VBoxContainer/FirstRowContainer/Seed3Button.connect("pressed",self, "_pressed_button_3");
	$VBoxContainer/FirstRowContainer/Seed4Button.connect("pressed",self, "_pressed_button_4");
	$VBoxContainer/SecondRowContainer/HBoxContainer/Seed5Button.connect("pressed",self, "_pressed_button_5");
	$VBoxContainer/SecondRowContainer/HBoxContainer/Seed6Button.connect("pressed",self, "_pressed_button_6");
	$VBoxContainer/SecondRowContainer/StartWateringButton.connect("pressed",self, "_press_start_watering_button");

func _pressed_button_1():
	emit_signal("seed_changed", PlaceableType.PlaceableType.SIMPLE);

func _pressed_button_2():
	print("this thing on?")
	emit_signal("seed_changed", PlaceableType.PlaceableType.STARVING)

func _pressed_button_3():
	emit_signal("seed_changed", PlaceableType.PlaceableType.VINE)

func _pressed_button_4():
	emit_signal("seed_changed", PlaceableType.PlaceableType.CORROSIVE)

func _pressed_button_5():
	emit_signal("seed_changed", PlaceableType.PlaceableType.GREEDY)

func _pressed_button_6():
	emit_signal("seed_changed", PlaceableType.PlaceableType.TUNNELING)
	
func _press_start_watering_button():
	emit_signal("start_watering_state");
