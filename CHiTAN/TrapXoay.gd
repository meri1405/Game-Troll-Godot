extends AnimatableBody2D

@export var rotation_angle: float = 90.0  # Góc xoay (độ)
@export var rotation_speed: float = 0.3   # Tốc độ xoay

var start_rotation: float
var target_rotation: float
var has_triggered = false
var is_rotating = false

@onready var trigger_area = $TriggerArea

func _ready():
	# Lưu góc xoay ban đầu
	start_rotation = rotation_degrees
	target_rotation = start_rotation + rotation_angle
	
	# Kết nối signal
	if trigger_area:
		trigger_area.body_entered.connect(_on_trigger_entered)
	
	add_to_group("moving_platforms")
	print("RotatingPlatform ready at rotation: ", start_rotation)

func _on_trigger_entered(body):
	if body.name.begins_with("CharacterBody2D") and not has_triggered:
		print("Player triggered platform rotation!")
		has_triggered = true
		rotate_platform()

func rotate_platform():
	if is_rotating:
		return
		
	is_rotating = true
	print("Platform rotating from ", rotation_degrees, " to ", target_rotation)
	
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", target_rotation, rotation_speed)
	tween.tween_callback(func(): 
		is_rotating = false
		print("Platform finished rotating")
	)

func reset_platform():
	print("Resetting platform rotation")
	rotation_degrees = start_rotation
	has_triggered = false
	is_rotating = false
