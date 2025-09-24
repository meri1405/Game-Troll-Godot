extends CharacterBody2D

var speed = 200
var triggered = false
var option : String
var direction = 1
var start_position: Vector2
# Called when the node enters the scene tree for the first time

func _ready() -> void:
	start_position=global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if triggered:
		match option:
			"right":
				print("right")
				velocity.y = 0
				velocity.x = direction * speed
			"left":
				print("left")
				velocity.y = 0
				velocity.x = direction * speed
			"up":
				print("up")
				velocity.x =0
				velocity.y = -direction * speed
			"down":
				print("down")
				velocity.x =0
				velocity.y = direction * speed
				
		
	move_and_slide()


func _on_box_trap_1_body_entered(body: Node2D) -> void:
	if body.name =="Player":
		print("spikehead 1")
		option = "down";
		triggered = true;


func _on_box_trap_2_body_entered(body: Node2D) -> void:
	if body.name =="Player":
		print("spikehead 2")
		option = "right";
		triggered = true;


func _on_box_trap_4_body_entered(body: Node2D) -> void:
	if body.name =="Player":
		print("spikehead 4")
		option = "up";
		triggered = true;


func _on_box_trap_3_body_entered(body: Node2D) -> void:
	if body.name =="Player":
		print("spikehead 3")
		option = "right";
		triggered = true;


func _on_box_trap_5_body_entered(body: Node2D) -> void:
	if body.name =="Player":
		print("spikehead 5")
		option = "right";
		triggered = true;
		

func _on_box_trap_6_body_entered(body: Node2D) -> void:
	if body.name =="Player":
		print("spikehead 6")
		option = "right";
		triggered = true;
		
func reset_trap():
	triggered = false
	velocity.x =0 
	velocity.y=0
	await get_tree().create_timer(1).timeout
	global_position=start_position
