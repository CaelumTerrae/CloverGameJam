extends Control
signal seed_changed(new_seed)
signal start_watering_state()


# Called when the node enters the scene tree for the first time.
func _ready():
	$PaletteVBoxContainer/HBoxContainer/SimpleButton.connect("pressed", self, "_pressed_simple_button")
	$PaletteVBoxContainer/HBoxContainer2/StarvingButton.connect("pressed", self, "_pressed_starving_button")
	$PaletteVBoxContainer/HBoxContainer3/VineButton.connect("pressed", self, "_pressed_vine_button")
	$PaletteVBoxContainer/HBoxContainer4/CorrosiveButton.connect("pressed", self, "_pressed_corrosive_button")
	$PaletteVBoxContainer/HBoxContainer5/GreedyButton.connect("pressed", self, "_pressed_greedy_button")
	$PaletteVBoxContainer/HBoxContainer6/TunnelingButton.connect("pressed", self, "_pressed_tunneling_button")
	$PaletteVBoxContainer/HBoxContainer7/RockButton.connect("pressed", self, "_pressed_rock_button")
	$PaletteVBoxContainer/HBoxContainer8/EraserButton.connect("pressed", self, "_pressed_eraser_button")
	
	$MarginContainer/TextureButton.connect("pressed", self, "_press_start_watering_button")
	$LostModalContainer/Control/MarginContainer/PlayAgainButton.connect("pressed", self, "_play_again")
		
	GameManager.connect("game_lost", self, "_show_lost_modal")
	GameManager.connect("seed_store_update", self, "_received_seed_store_update")

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

func _received_seed_store_update():
	var seed_store = GameManager.seed_store
	
	$PaletteVBoxContainer/HBoxContainer/Control/SimpleLabel.set_text(String(seed_store.get_count(PlaceableType.PlaceableType.SIMPLE)))
	$PaletteVBoxContainer/HBoxContainer2/Control/StarvingLabel.set_text(String(seed_store.get_count(PlaceableType.PlaceableType.STARVING)))
	$PaletteVBoxContainer/HBoxContainer3/Control/VineLabel.set_text(String(seed_store.get_count(PlaceableType.PlaceableType.VINE)))
	$PaletteVBoxContainer/HBoxContainer4/Control/CorrosiveLabel.set_text(String(seed_store.get_count(PlaceableType.PlaceableType.CORROSIVE)))
	$PaletteVBoxContainer/HBoxContainer5/Control/GreedyLabel.set_text(String(seed_store.get_count(PlaceableType.PlaceableType.GREEDY)))
	$PaletteVBoxContainer/HBoxContainer6/Control/TunnelingLabel.set_text(String(seed_store.get_count(PlaceableType.PlaceableType.TUNNELING)))
	$PaletteVBoxContainer/HBoxContainer7/Control/RockLabel.set_text(String(seed_store.get_count(PlaceableType.PlaceableType.ROCK)))
	
	pass
