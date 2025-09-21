extends CharacterBody2D

@export var speed: float = 200.0
@export var direction: int = -1
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var triggered: bool = false
var start_position: Vector2

func _ready():
	start_position = global_position
	
	

func _physics_process(delta: float) -> void:
	if triggered:
		global_position.x += direction * speed * delta
		animated_sprite_2d.animation = "running"
	if global_position.x < 13200 :
		animated_sprite_2d.animation = "dead"
		await get_tree().create_timer(1.0).timeout
		queue_free()
		print("Delete_fire")
	

func _on_saw_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Spike activated!")
		triggered = true

func reset_trap():
	global_position = start_position
	triggered = false
	animated_sprite_2d.animation = "up"
