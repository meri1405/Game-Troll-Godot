extends CharacterBody2D


const SPEED = 260
var triggered = false
var perma_end = false
var start_pos : Vector2

func _ready() -> void:
	start_pos = global_position

func _physics_process(delta: float) -> void:
	velocity.y = 0
	
	if triggered and not perma_end:
		velocity.x = SPEED
	move_and_slide()


func _on_player_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		triggered = true
		

func _on_tile_body_entered(body: Node2D) -> void:
	print(body.name)
	if body.name == "tileGoGo":
		print("stop")
		triggered = false
		perma_end = true
		velocity.x = 0

func reset_trap():
	triggered = false
	velocity.x = 0
	await get_tree().create_timer(1).timeout
	global_position = start_pos
