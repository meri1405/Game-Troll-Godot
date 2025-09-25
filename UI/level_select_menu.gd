extends Control

@onready var grid_container = $VBoxContainer/GridContainer
@onready var back_button = $VBoxContainer/HBoxContainer/BackButton
@onready var reset_button = $VBoxContainer/HBoxContainer/ResetButton
@onready var title = $VBoxContainer/Title

const MAX_LEVELS = 11

func _ready():
	setup_ui()
	create_level_buttons()
	connect_signals()

func setup_ui():
	title.text = "SELECT LEVEL"

func create_level_buttons():
	# Setup TouchScreenButtons có sẵn trong scene
	for i in range(1, MAX_LEVELS + 1):
		var button_path = "VBoxContainer/GridContainer/Level" + str(i) + "Button"
		var button = get_node_or_null(button_path) as TouchScreenButton
		
		if button:
			setup_level_button(button, i)

func setup_level_button(button: TouchScreenButton, level_num: int):
	var is_unlocked = GameManager.is_level_unlocked(level_num)
	
	# Disconnect existing signals
	if button.pressed.get_connections().size() > 0:
		for connection in button.pressed.get_connections():
			button.pressed.disconnect(connection.callable)
	
	if is_unlocked:
		# Level unlocked
		button.modulate = Color.WHITE
		button.pressed.connect(_on_level_selected.bind(level_num))
	else:
		# Level locked
		var lock_texture
		if lock_texture:
			button.texture_normal = lock_texture
		button.modulate = Color.GRAY

# Helper functions không cần thiết nữa - buttons đã được tạo trong scene

func connect_signals():
	if back_button:
		back_button.pressed.connect(_on_back_pressed)
	if reset_button:
		reset_button.pressed.connect(_on_reset_pressed)
	
	# Listen for level unlocks
	GameManager.level_unlocked.connect(_on_level_unlocked)

func _on_level_selected(level_number: int):
	$"/root/AudioController".play_click()
	GameManager.go_to_level(level_number)

func _on_back_pressed():
	$"/root/AudioController".play_click()
	get_tree().change_scene_to_file("res://All_Level/Scene Main Start/main.tscn")

func _on_reset_pressed():
	GameManager.max_level_unlocked = 1
	GameManager.current_level = 1
	GameManager.save_progress()
	create_level_buttons()

func _on_level_unlocked(level_number: int):
	create_level_buttons()
