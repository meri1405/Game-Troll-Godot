extends Control

@onready var grid_container = $VBoxContainer/GridContainer
@onready var back_button = $VBoxContainer/HBoxContainer/BackButton
@onready var reset_button = $VBoxContainer/HBoxContainer/ResetButton
@onready var title = $VBoxContainer/Title

const MAX_LEVELS = 10

func _ready():
	setup_ui()
	setup_grid_container()
	create_level_buttons()
	connect_signals()
	
	# Debug: Enable global input processing
	set_process_input(true)
	
	print("Level select menu ready with pre-created buttons")

func _input(event):
	# Debug: Log touch events để kiểm tra
	if event is InputEventScreenTouch:
		print("Screen touch at: ", event.position, " pressed: ", event.pressed)
		
		# Kiểm tra touch có trong vùng GridContainer không
		var grid_rect = grid_container.get_global_rect()
		var vbox_rect = $VBoxContainer.get_global_rect()
		print("VBoxContainer rect: ", vbox_rect)
		print("GridContainer rect: ", grid_rect)
		print("Touch in VBoxContainer: ", vbox_rect.has_point(event.position))
		print("Touch in GridContainer: ", grid_rect.has_point(event.position))

func setup_ui():
	title.text = "SELECT LEVEL"
	
	# Background đã được thiết lập trong scene với anchors
	var bg = get_node_or_null("TextureRect")
	if bg:
		# Đảm bảo background không chặn touch events
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE

func setup_grid_container():
	# Setup cho icons lớn
	grid_container.columns = 5
	grid_container.add_theme_constant_override("h_separation", 20)
	grid_container.add_theme_constant_override("v_separation", 20)
	
	# DEBUG: Kiểm tra GridContainer settings
	print("GridContainer mouse_filter: ", grid_container.mouse_filter)
	
	# Đảm bảo GridContainer không chặn events
	grid_container.mouse_filter = Control.MOUSE_FILTER_PASS

func create_level_buttons():
	# Sử dụng TouchScreenButtons có sẵn trong scene
	for i in range(1, MAX_LEVELS + 1):
		var button_path = "VBoxContainer/GridContainer/Level" + str(i) + "Button"
		var button = get_node_or_null(button_path) as TouchScreenButton
		
		if button:
			setup_level_button(button, i)
			print("Setup existing TouchScreenButton for level: ", i)
		else:
			print("TouchScreenButton not found: ", button_path)

func setup_level_button(button: TouchScreenButton, level_num: int):
	var is_unlocked = GameManager.is_level_unlocked(level_num)
	
	# Disconnect any existing signals first
	if button.pressed.get_connections().size() > 0:
		for connection in button.pressed.get_connections():
			button.pressed.disconnect(connection.callable)
	
	if is_unlocked:
		# Level unlocked - icon đã được set trong scene
		button.modulate = Color.WHITE
		button.visible = true
		
		# Connect signals - TouchScreenButton sử dụng pressed signal
		button.pressed.connect(_on_level_selected.bind(level_num))
		
		print("Connected TouchScreenButton for level: ", level_num)
	else:
		# Level locked - thay đổi texture thành lock icon
		var lock_texture = load("res://UI/icons/lock.png")
		if lock_texture:
			button.texture_normal = lock_texture
		button.modulate = Color.GRAY
		button.visible = true
		
		print("Level ", level_num, " is locked")

# Helper functions không cần thiết nữa - buttons đã được tạo trong scene

func connect_signals():
	if back_button:
		# Cải thiện size cho mobile
		back_button.custom_minimum_size = Vector2(120, 60)
		back_button.focus_mode = Control.FOCUS_NONE
		back_button.mouse_filter = Control.MOUSE_FILTER_PASS
		back_button.pressed.connect(_on_back_pressed)
		# Thêm gui_input để xử lý touch trực tiếp
		back_button.gui_input.connect(_on_back_button_input)
		
	if reset_button:
		# Cải thiện size cho mobile
		reset_button.custom_minimum_size = Vector2(140, 60)
		reset_button.focus_mode = Control.FOCUS_NONE
		reset_button.mouse_filter = Control.MOUSE_FILTER_PASS
		reset_button.pressed.connect(_on_reset_pressed)
		# Thêm gui_input để xử lý touch trực tiếp
		reset_button.gui_input.connect(_on_reset_button_input)
	
	# Listen for level unlocks
	GameManager.level_unlocked.connect(_on_level_unlocked)

func _on_level_selected(level_number: int):
	print("🎯 LEVEL BUTTON PRESSED: ", level_number)  # Debug với emoji để dễ thấy
	$"/root/AudioController".play_click()
	GameManager.go_to_level(level_number)

func _on_back_button_input(event: InputEvent):
	if event is InputEventScreenTouch and not event.pressed:
		print("Back button touched")
		_on_back_pressed()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Back button clicked")
		_on_back_pressed()

func _on_reset_button_input(event: InputEvent):
	if event is InputEventScreenTouch and not event.pressed:
		print("Reset button touched")
		_on_reset_pressed()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Reset button clicked")
		_on_reset_pressed()

func _on_back_pressed():
	print("Back button pressed")  # Debug
	$"/root/AudioController".play_click()
	get_tree().change_scene_to_file("res://All_Level/Scene Main Start/main.tscn")

func _on_reset_pressed():
	GameManager.max_level_unlocked = 1
	GameManager.current_level = 1
	GameManager.save_progress()
	create_level_buttons()
	print("Progress reset!")

func _on_level_unlocked(level_number: int):
	create_level_buttons()
	print("Level ", level_number, " unlocked!")
