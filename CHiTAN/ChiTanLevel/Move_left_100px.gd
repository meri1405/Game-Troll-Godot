extends AnimatableBody2D

@export var move_distance: float = 130.0
@export var move_speed: float = 0.1
@export var move_direction: Vector2 = Vector2(-1, 0)  # Hướng di chuyển (phải)

var start_position: Vector2
var target_position: Vector2
var has_triggered = false
var is_moving = false

@onready var trigger_area = $TriggerArea

func _ready():
	# Lưu vị trí ban đầu
	start_position = global_position
	target_position = start_position + (move_direction.normalized() * move_distance)
	
	# Kết nối signal
	if trigger_area:
		trigger_area.body_entered.connect(_on_trigger_entered)
	
	# Thêm vào group để reset
	add_to_group("moving_platforms")
	
	print("MovingPlatform ready at: ", global_position)

func _on_trigger_entered(body):
	if body.name.begins_with("CharacterBody2D") and not has_triggered:
		print("Player triggered platform movement!")
		has_triggered = true
		move_platform()

func move_platform():
	if is_moving:
		return
		
	is_moving = true
	print("Platform moving from ", global_position, " to ", target_position)
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, move_speed)
	tween.tween_callback(func(): 
		is_moving = false
		print("Platform finished moving")
	)

func reset_platform():
	print("Resetting platform to start position")
	
	# Dừng movement nếu đang di chuyển
	if is_moving:
		var tweens = get_tree().get_nodes_in_group("Tween")
		for tween in tweens:
			if tween.get_parent() == self:
				tween.kill()
	
	# Reset properties
	global_position = start_position
	has_triggered = false
	is_moving = false
