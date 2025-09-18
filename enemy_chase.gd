extends CharacterBody2D

@export var SPEED: float = 280.0
@export var attack_range: float = 100.0
@export var chase_range: float = 1000.0

@onready var target: Node2D = %Player
@onready var anim: AnimatedSprite2D = %AnimatedSprite2D

var state: String = "idle"
var start_position: Vector2   # lưu vị trí gốc

func _ready():
	start_position = global_position  # lưu vị trí ban đầu
	anim.play("spwan")
	set_physics_process(false)


func start_spawn():
	state = "spawning"
	set_physics_process(true)
	anim.play("spawn")

	await get_tree().create_timer(1.0).timeout
	state = "waiting"
	anim.play("idle")

	await get_tree().create_timer(2.0).timeout
	if state == "waiting":
		state = "running"
		anim.play("running")


func _physics_process(delta: float) -> void:
	if not target:
		return

	var dist = global_position.distance_to(target.global_position)

	match state:
		"running":
			if dist < attack_range:
				state = "attacking"
				anim.play("attack")
				velocity = Vector2.ZERO
				return
			elif dist < chase_range:
				var dir = (target.position - position).normalized()
				velocity = dir * SPEED
				move_and_slide()
				look_at(target.position)
			else:
				velocity = Vector2.ZERO

		"attacking":
			if not anim.is_playing():
				state = "running"
				anim.play("running")


# Hàm reset enemy (gọi khi player reset game)
func reset_trap():
	global_position = start_position   # về vị trí ban đầu
	state = "spawning"
	set_physics_process(false)         # ngừng hoạt động
	anim.play("spwan")
	hide()
