extends Node2D

@export var spike_scene: PackedScene
@export var spawn_area_width: float = 380.0
@export var spawn_interval: float = 0.5  # giây giữa mỗi lần spawn

func _ready():
	spawn_spikes()

func spawn_spikes():
	while true:
		var spike = spike_scene.instantiate()
		add_child(spike)

		# Random vị trí X quanh spawner
		var x = randf_range(-spawn_area_width / 2, spawn_area_width / 2)
		spike.position = Vector2(x, 0)

		# Chờ vài giây rồi tạo tiếp
		await get_tree().create_timer(spawn_interval).timeout
