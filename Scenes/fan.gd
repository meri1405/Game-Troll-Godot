extends CharacterBody2D


const SPEED = 400
const JUMP_VELOCITY = -400.0
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var triggered = false 
var direction = -1

func _ready() -> void:
	sprite_2d.speed_scale = 10


func _physics_process(delta: float) -> void:
	if triggered:
		velocity.y = direction * SPEED

	move_and_slide()


func _on_fan_trigger_body_entered(body: Node2D) -> void:
	triggered = true
