extends Node



# Settings
const DEATHS_PER_POPUP = 5
const SAVE_FILE = "user://death5_popup_data.dat"

# Data
var total_deaths: int = 0
var deaths_since_last_popup: int = 0


var popup_scene_path: String = "res://UI/game_over.tscn"  # ← THAY ĐỔI SCENE TẠI ĐÂY


# Signals
signal popup_triggered(death_count: int)
signal death_count_updated(current: int, next_popup_at: int)

func _ready():
	_load_data()
	print("✅ Death5PopupManager initialized")
	print("💀 Deaths since last popup: ", deaths_since_last_popup, "/", DEATHS_PER_POPUP)

# === PUBLIC API ===
func add_death() -> bool:
	deaths_since_last_popup += 1
	total_deaths += 1
	
	death_count_updated.emit(deaths_since_last_popup, DEATHS_PER_POPUP)
	_save_data()
	
	print("💀 Death added: %d/%d deaths since last popup" % [deaths_since_last_popup, DEATHS_PER_POPUP])
	
	if deaths_since_last_popup >= DEATHS_PER_POPUP:
		_trigger_popup()
		return true
	
	return false

func _trigger_popup():
	deaths_since_last_popup = 0
	popup_triggered.emit(total_deaths)
	_save_data()
	
	print("🎮 Showing popup after 5 deaths!")
	_show_popup()

func _show_popup():
	"""Hiển thị popup scene"""
	print("🔍 Starting _show_popup...")
	print("📁 Popup scene path: ", popup_scene_path)
	
	# Kiểm tra scene có tồn tại không
	if not ResourceLoader.exists(popup_scene_path):
		push_error("❌ Scene not found, using code popup: " + popup_scene_path)
		_create_simple_popup()
		return
	
	# Load và hiển thị scene
	var popup_scene = load(popup_scene_path)
	if not popup_scene:
		push_error("❌ Failed to load scene, using code popup: " + popup_scene_path)
		_create_simple_popup()
		return
	
	var popup_instance = popup_scene.instantiate()
	var current_scene = get_tree().current_scene
	
	if not current_scene:
		push_error("❌ No current scene!")
		return
	
	# Tạo CanvasLayer
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	canvas_layer.name = "Death5PopupLayer"
	
	# Add popup vào CanvasLayer
	canvas_layer.add_child(popup_instance)
	current_scene.add_child(canvas_layer)
	
	print("✅ Scene popup shown: ", popup_scene_path)
	
	# Connect signals nếu có
	if popup_instance.has_signal("popup_closed"):
		popup_instance.popup_closed.connect(_on_popup_closed)
		popup_instance.popup_closed.connect(func(): canvas_layer.queue_free())
	
	# Nếu không có signal, auto close sau 5 giây
	get_tree().create_timer(5.0).timeout.connect(func():
		if is_instance_valid(canvas_layer):
			print("⏰ Auto closing popup after 5 seconds")
			canvas_layer.queue_free()
	)

func _create_simple_popup():
	"""Tạo popup đơn giản bằng code"""
	print("🔨 Creating simple popup with code...")
	
	var current_scene = get_tree().current_scene
	if not current_scene:
		push_error("❌ No current scene!")
		return
	
	# Tạo CanvasLayer
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	canvas_layer.name = "Death5PopupLayer"
	
	# Tạo Control chính
	var popup_control = Control.new()
	popup_control.name = "Death5Popup"
	popup_control.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	# Background đen trong suốt
	var background = ColorRect.new()
	background.color = Color(0, 0, 0, 0.8)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	popup_control.add_child(background)
	
	# Panel trung tâm
	var center_panel = Panel.new()
	center_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	center_panel.size = Vector2(400, 300)
	center_panel.position = Vector2(-200, -150)
	
	# Style cho panel
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.2, 0.6, 1.0, 0.9)
	style.corner_radius_top_left = 15
	style.corner_radius_top_right = 15
	style.corner_radius_bottom_left = 15
	style.corner_radius_bottom_right = 15
	style.border_width_left = 3
	style.border_width_top = 3
	style.border_width_right = 3
	style.border_width_bottom = 3
	style.border_color = Color.YELLOW
	center_panel.add_theme_stylebox_override("panel", style)
	
	popup_control.add_child(center_panel)
	
	# Label title
	var title_label = Label.new()
	title_label.text = "🎉 POPUP HIỂN THỊ THÀNH CÔNG! 🎉"
	title_label.position = Vector2(20, 50)
	title_label.size = Vector2(360, 50)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 24)
	title_label.add_theme_color_override("font_color", Color.WHITE)
	center_panel.add_child(title_label)
	
	# Description
	var desc_label = Label.new()
	desc_label.text = "✅ Death5PopupManager hoạt động!\n💀 Popup sau mỗi 5 lần chết\n🎮 Hệ thống sẵn sàng!"
	desc_label.position = Vector2(20, 120)
	desc_label.size = Vector2(360, 100)
	desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	desc_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	desc_label.add_theme_font_size_override("font_size", 16)
	desc_label.add_theme_color_override("font_color", Color.WHITE)
	center_panel.add_child(desc_label)
	
	# Close button
	var close_button = Button.new()
	close_button.text = "❌ Đóng"
	close_button.position = Vector2(150, 240)
	close_button.size = Vector2(100, 40)
	close_button.add_theme_font_size_override("font_size", 16)
	center_panel.add_child(close_button)
	
	# Connect close button
	close_button.pressed.connect(func(): 
		print("🗑️ Closing popup...")
		canvas_layer.queue_free()
	)
	
	# Add to scene
	canvas_layer.add_child(popup_control)
	current_scene.add_child(canvas_layer)
	
	# Animation
	popup_control.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(popup_control, "modulate:a", 1.0, 0.3)
	
	print("✅ Simple popup created and shown!")
	print("📍 Canvas layer added to: ", current_scene.name)

func _on_popup_closed():
	print("📴 Popup closed")

func set_popup_scene_path(path: String) -> void:
	popup_scene_path = path
	# Không tự động save - chỉ thay đổi runtime
	print("📁 Popup scene path set to: ", path)
	print("⚠️ Lưu ý: Thay đổi này chỉ có hiệu lực trong session hiện tại")
	print("💡 Để thay đổi vĩnh viễn, sửa trực tiếp trong code dòng 12")

func get_deaths_until_popup() -> int:
	return max(0, DEATHS_PER_POPUP - deaths_since_last_popup)

func reset_death_count() -> void:
	deaths_since_last_popup = 0
	death_count_updated.emit(deaths_since_last_popup, DEATHS_PER_POPUP)
	_save_data()
	print("🔄 Death count reset to 0")

# === SAVE/LOAD DATA ===
func _save_data():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file == null:
		push_error("Cannot save Death5Popup data!")
		return
	
	var data = {
		"version": 1,
		"total_deaths": total_deaths,
		"deaths_since_last_popup": deaths_since_last_popup,
		# KHÔNG lưu popup_scene_path - đọc trực tiếp từ code
		"timestamp": Time.get_unix_time_from_system()
	}
	
	file.store_var(data, true)
	file.close()

func _load_data():
	if not FileAccess.file_exists(SAVE_FILE):
		return
	
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file == null:
		push_error("Cannot load Death5Popup data!")
		return
	
	var data = file.get_var(true)
	file.close()
	
	if typeof(data) != TYPE_DICTIONARY:
		return
	
	total_deaths = data.get("total_deaths", 0)
	deaths_since_last_popup = data.get("deaths_since_last_popup", 0)
	
	# popup_scene_path LUÔN đọc từ code, không load từ file
	# Đường dẫn được set ở dòng 12: var popup_scene_path: String = "res://UI/game_over.tscn"
	
	# Validate data
	deaths_since_last_popup = clampi(deaths_since_last_popup, 0, DEATHS_PER_POPUP)
	total_deaths = max(0, total_deaths)
	
	print("📂 Loaded data - Using popup path from code: ", popup_scene_path)

# === DEBUG FUNCTIONS ===
func debug_trigger_popup():
	print("🧪 Debug: Forcing popup trigger")
	deaths_since_last_popup = DEATHS_PER_POPUP
	_trigger_popup()

func debug_add_deaths(count: int):
	for i in range(count):
		add_death()

func debug_show_status():
	print("=== Death5Popup Status ===")
	print("Total deaths: ", total_deaths)
	print("Deaths since last popup: ", deaths_since_last_popup, "/", DEATHS_PER_POPUP)
	print("Deaths until next popup: ", get_deaths_until_popup())
	print("Popup scene path: ", popup_scene_path)
	print("========================")

func debug_check_scene_tree():
	print("=== Scene Tree Debug ===")
	var current_scene = get_tree().current_scene
	if current_scene:
		print("📍 Current scene: ", current_scene.name)
		print("📍 Current scene type: ", current_scene.get_class())
		print("📍 Children count: ", current_scene.get_child_count())
		for child in current_scene.get_children():
			print("  - Child: ", child.name, " (", child.get_class(), ")")
	else:
		print("❌ No current scene!")
	print("===================")

func debug_test_simple_popup():
	print("🧪 Testing simple popup creation...")
	_create_simple_popup()

func debug_reset_save_file():
	"""Xóa file save để reset hoàn toàn"""
	if FileAccess.file_exists(SAVE_FILE):
		DirAccess.remove_absolute(SAVE_FILE)
		print("🗑️ Save file deleted!")
		total_deaths = 0
		deaths_since_last_popup = 0
		print("✅ Data reset - Using new popup path: ", popup_scene_path)
	else:
		print("ℹ️ No save file to delete")
