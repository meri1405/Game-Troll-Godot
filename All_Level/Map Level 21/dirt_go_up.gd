extends CharacterBody2D


const SPEED = 2000
const JUMP_VELOCITY = -400.0
var direction= -1
var triggered = false
var start_pos : Vector2

func _ready() -> void:
	start_pos = global_position

func _physics_process(delta: float) -> void:
	if triggered:
		velocity.y = direction * SPEED
	if global_position.y < 360:
			triggered = false
			velocity.y = 0
	move_and_slide()

func _on_dirt_up_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		triggered = true
		print("activated")

func reset_trap():
	triggered = false
	velocity.x = 0
	await get_tree().create_timer(1).timeout
	global_position = start_pos
