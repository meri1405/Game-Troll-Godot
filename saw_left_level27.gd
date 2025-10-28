extends AnimatableBody2D

@export var speed: float = 280.0
@export var direction: int = -1
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

var triggered: bool = false
var start_position: Vector2

func _ready():
	start_position = global_position
	visible = false
	set_physics_process(false)
	

func _physics_process(delta: float) -> void:
	if triggered:
		global_position.x += direction * speed * delta
		visible = true
		sprite_2d.animation = "default"
	if global_position.x < 280: #đến đoạn này thì chữ sẽ dừng lại và vẫn hiện đó 
		global_position.x = 280
		visible = true
		sprite_2d.animation = "default"
		
		

func _on_saw_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Saw activated!")
		triggered = true
		visible = true
		set_physics_process(true)

func reset_trap():
	global_position = start_position
	triggered = false
	visible = false
	set_physics_process(false)
