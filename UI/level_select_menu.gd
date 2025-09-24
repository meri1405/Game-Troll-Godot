extends Control

@onready var grid_container = $VBoxContainer/ScrollContainer/GridContainer
@onready var back_button = $VBoxContainer/HBoxContainer/BackButton
@onready var reset_button = $VBoxContainer/HBoxContainer/ResetButton
@onready var title = $VBoxContainer/Title

const MAX_LEVELS = 10

func _ready():
	setup_ui()
	setup_grid_container()
	create_level_buttons()
	connect_signals()

func setup_ui():
	title.text = "SELECT LEVEL"
	
	# Thiết lập background
	var bg = get_node_or_null("TextureRect")
	if bg:
		bg.modulate = Color(1, 1, 1, 0.95)

func setup_grid_container():
	# Setup cho icons lớn
	grid_container.columns = 5
	grid_container.add_theme_constant_override("h_separation", 0)
	grid_container.add_theme_constant_override("v_separation", 0)

func create_level_buttons():
	# Xóa buttons cũ
	for child in grid_container.get_children():
		child.queue_free()
	
	# Đợi 1 frame để nodes được xóa hoàn toàn
	await get_tree().process_frame
	
	# Tạo buttons với PNG icons
	for i in range(1, MAX_LEVELS + 1):
		var button = create_level_button_with_icon(i)
		grid_container.add_child(button)

func create_level_button_with_icon(level_num: int) -> Control:
	# Container lớn hơn
	var container = Control.new()
	container.custom_minimum_size = Vector2(140, 140)
	
	# Background để debug (tùy chọn)
	var bg = ColorRect.new()
	bg.anchors_preset = Control.PRESET_FULL_RECT
	bg.color = Color(0.3, 0.3, 0.3, 0.1)  # Transparent background
	container.add_child(bg)
	
	# Button trong suốt
	var button = Button.new()
	button.anchors_preset = Control.PRESET_FULL_RECT
	button.custom_minimum_size = Vector2(90, 90)
	button.flat = true
	container.add_child(button)
	
	# Icon lớn hơn với padding
	var icon = TextureRect.new()
	icon.anchors_preset = Control.PRESET_CENTER
	icon.custom_minimum_size = Vector2(90, 90)
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	container.add_child(icon)
	
	# Label backup lớn hơn
	var label = Label.new()
	label.anchors_preset = Control.PRESET_CENTER
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 48)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	container.add_child(label)
	
	var is_unlocked = GameManager.is_level_unlocked(level_num)
	
	if is_unlocked:
		# Level unlocked - load PNG icon
		var icon_path = "res://UI/icons/level_" + str(level_num) + ".png"
		
		if FileAccess.file_exists(icon_path):
			# Có PNG icon - dùng icon
			icon.texture = load(icon_path)
			icon.visible = true
			label.visible = false
			# Scale icon lên nếu cần
			icon.scale = Vector2(1.1, 1.1)
		else:
			# Không có PNG - dùng số với background màu
			icon.visible = false
			label.visible = true
			label.text = str(level_num)
			label.modulate = Color.WHITE
			# Tạo background cho số
			bg.color = Color(0.2, 0.8, 1.0, 0.8)  # Cyan background
		
		button.disabled = false
		container.modulate = Color.WHITE
		button.pressed.connect(_on_level_selected.bind(level_num))
		
		# BỎ HOVER EFFECTS cho mobile
		# button.mouse_entered.connect(_on_icon_button_hover.bind(container))
		# button.mouse_exited.connect(_on_icon_button_unhover.bind(container))
		
	else:
		# Level locked
		var lock_path = "res://UI/icons/lock.png"
		
		if FileAccess.file_exists(lock_path):
			# Có lock icon
			icon.texture = load(lock_path)
			icon.visible = true
			label.visible = false
			icon.scale = Vector2(1.2, 1.2)
		else:
			# Không có lock icon - dùng emoji
			icon.visible = false
			label.visible = true
			label.text = "🔒"
			label.add_theme_font_size_override("font_size", 64)
			bg.color = Color.GRAY
		
		button.disabled = true
		container.modulate = Color.GRAY
	
	return container

# BỎ CÁC FUNCTION HOVER ANIMATION
# func _on_icon_button_hover(container: Control):
# func _on_icon_button_unhover(container: Control):

# Helper function để tạo texture backup
func create_number_texture(number: int) -> ImageTexture:
	var image = Image.create(128, 128, false, Image.FORMAT_RGBA8)
	image.fill(Color.CYAN)
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture

func create_lock_texture() -> ImageTexture:
	var image = Image.create(128, 128, false, Image.FORMAT_RGBA8)
	image.fill(Color.GRAY)
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture

func connect_signals():
	if back_button:
		back_button.pressed.connect(_on_back_pressed)
	if reset_button:
		reset_button.pressed.connect(_on_reset_pressed)
	
	# Listen for level unlocks
	GameManager.level_unlocked.connect(_on_level_unlocked)

func _on_level_selected(level_number: int):
	print("Selected level: ", level_number)
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
	print("Progress reset!")

func _on_level_unlocked(level_number: int):
	create_level_buttons()
	print("Level ", level_number, " unlocked!")
