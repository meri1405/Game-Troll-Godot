extends Area2D

@export var speed: float = 800.0
@export var direction: int = 1   # 1 = sang phải, -1 = sang trái

var triggered: bool = false
var start_position: Vector2

func _ready():
	start_position = global_position
	visible = false                 # Ẩn gai ban đầu
	set_physics_process(false)      # Chưa cho chạy

func _physics_process(delta: float) -> void:
	if triggered:
		global_position.x += direction * speed * delta

		# Khi đi quá giới hạn thì tắt
		if global_position.x > 1000:
			visible = false
			set_physics_process(false)

func _on_saw_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Saw activated!")
		triggered = true
		visible = true              # Hiện lên khi player chạm trigger
		set_physics_process(true)   # Bắt đầu chạy

func reset_trap():
	global_position = start_position
	triggered = false
	visible = false
	set_physics_process(false)
