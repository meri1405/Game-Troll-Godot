extends Node2D

@export var Fire_scene: PackedScene
@export var spawn_area_width: float = 350.0
@export var spawn_interval: float = 1  # giây giữa mỗi lần spawn

func _ready():
	spawn_spikes()

func spawn_spikes():
	while true:
		var Fire = Fire_scene.instantiate()
		add_child(Fire)

		# Random vị trí X quanh spawner
		var x = randf_range(-spawn_area_width / 2, spawn_area_width / 2)
		Fire.position = Vector2(x, 0)

		# Chờ vài giây rồi tạo tiếp
		await get_tree().create_timer(spawn_interval).timeout
