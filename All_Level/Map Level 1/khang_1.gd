extends Node2D

@onready var tilemap: TileMap = $TileMap  

# Danh sách tile cần ẩn khi bắt đầu
var grass_tiles = [
	Vector2i(12, 11),
	Vector2i(13, 11),
	Vector2i(14, 11),
	Vector2i(15, 11),
	Vector2i(16, 11),
	Vector2i(17, 11),
	Vector2i(18, 11),
	Vector2i(19, 11),
	Vector2i(20, 11),
	Vector2i(21, 11),
	Vector2i(22, 9),
	Vector2i(22, 10)
]

func _ready():
	# Khi scene vừa load -> xóa tile
	for coords in grass_tiles:
		tilemap.set_cell(0, coords, -1)  # -1 = clear tile
		
	# Tải cài đặt âm thanh khi khởi động game
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		AudioServer.set_bus_mute(0, config.get_value("audio", "muted", false))

func _on_menu_button_pressed():
	$PauseMenu.show_menu()
