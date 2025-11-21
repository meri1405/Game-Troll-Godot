extends Area2D

@export var tilemap: TileMap
@export var tile_positions := [Vector2i(35, 10), Vector2i(36, 10)]
@export var player_group := "Player"

var saved_tiles = []
var triggered := false


func _ready():
	save_and_clear_tiles()


# ----------------------------------------------
# Lưu tile bằng API chuẩn Godot 4
# → Không dùng TileData nữa
# ----------------------------------------------
func save_and_clear_tiles():
	saved_tiles.clear()

	for pos in tile_positions:
		var tile_data = {
			"pos": pos,
			"source": tilemap.get_cell_source_id(0, pos),
			"atlas": tilemap.get_cell_atlas_coords(0, pos),
			"alt": tilemap.get_cell_alternative_tile(0, pos)
		}

		saved_tiles.append(tile_data)

		# Ẩn tile ban đầu
		tilemap.set_cell(0, pos, -1)


func _on_body_entered(body):
	if triggered: return
	if not body.is_in_group(player_group): return

	triggered = true
	spawn_tiles()


func spawn_tiles():
	for data in saved_tiles:
		tilemap.set_cell(
			0,
			data["pos"],
			data["source"],
			data["atlas"],
			data["alt"]
		)


func _process(_delta):
	var player = get_tree().get_first_node_in_group(player_group)
	if triggered and player and not player.is_alive:
		reset_tiles()


func reset_tiles():
	for data in saved_tiles:
		tilemap.set_cell(0, data["pos"], -1)

	triggered = false
