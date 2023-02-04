extends Control
signal seed_changed(new_seed)
signal start_watering_state()


# Called when the node enters the scene tree for the first time.
func _ready():
	$PaletteVBoxContainer/SimpleButton.connect("pressed", self, "_pressed_simple_button")
	$PaletteVBoxContainer/StarvingButton.connect("pressed", self, "_pressed_starving_button")
	$PaletteVBoxContainer/VineButton.connect("pressed", self, "_pressed_vine_button")
	$PaletteVBoxContainer/CorrosiveButton.connect("pressed", self, "_pressed_corrosive_button")
	$PaletteVBoxContainer/GreedyButton.connect("pressed", self, "_pressed_greedy_button")
	$PaletteVBoxContainer/TunnelingButton.connect("pressed", self, "_pressed_tunneling_button")
	$PaletteVBoxContainer/RockButton.connect("pressed", self, "_pressed_rock_button")
	$PaletteVBoxContainer/EraserButton.connect("pressed", self, "_pressed_eraser_button")
	
	$MarginContainer/TextureButton.connect("pressed", self, "_press_start_watering_button")
	$LostModalContainer/Control/MarginContainer/PlayAgainButton.connect("pressed", self, "_play_again")
	
	GameManager.connect("game_lost", self, "_show_lost_modal")

func _pressed_simple_button():
	emit_signal("seed_changed", PlaceableType.PlaceableType.SIMPLE);

func _pressed_starving_button():
	print("this thing on?")
	emit_signal("seed_changed", PlaceableType.PlaceableType.STARVING)

func _pressed_vine_button():
	emit_signal("seed_changed", PlaceableType.PlaceableType.VINE)

func _pressed_corrosive_button():
	emit_signal("seed_changed", PlaceableType.PlaceableType.CORROSIVE)

func _pressed_greedy_button():
	emit_signal("seed_changed", PlaceableType.PlaceableType.GREEDY)

func _pressed_tunneling_button():
	emit_signal("seed_changed", PlaceableType.PlaceableType.TUNNELING)

func _pressed_rock_button():
	emit_signal("seed_changed", PlaceableType.PlaceableType.ROCK)

func _pressed_eraser_button():
	emit_signal("seed_changed", PlaceableType.PlaceableType.EMPTY)
	
func _press_start_watering_button():
	emit_signal("start_watering_state");

func _show_lost_modal():
	$LostModalContainer.set_visible(true)

func _play_again():
	print("clicked the play_again button")
	# set the visibility to none
	$LostModalContainer.set_visible(false)
	GameManager.reset_level()
