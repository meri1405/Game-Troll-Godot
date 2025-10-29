extends CharacterBody2D


const SPEED = 1000
const JUMP_VELOCITY = -400.0
var direction= 1
var triggered = false
var start_pos : Vector2

func _ready() -> void:
	start_pos = global_position

func _physics_process(delta: float) -> void:
	if triggered:
		velocity.x = direction * SPEED
		visible = true
	if global_position.x > 3600:
			triggered = false
			velocity.x = 0
	move_and_slide()

func _on_dirt_up_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		triggered = true
		print("activated")

func reset_trap():
	triggered = false
	velocity.x = 0
	visible = false
	await get_tree().create_timer(1).timeout
	global_position = start_pos
