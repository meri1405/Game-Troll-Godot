extends CharacterBody2D


const speed = 300.0
const JUMP_VELOCITY = -400.0
var direction = -1
var start_position: Vector2

func _ready() -> void:
	start_position= global_position
	print(start_position)

func _physics_process(delta: float) -> void:
	
	velocity.x = direction * speed 
	print(global_position)
	await get_tree().create_timer(5).timeout
	reset_trap()
	move_and_slide()

func reset_trap():
	global_position = start_position
