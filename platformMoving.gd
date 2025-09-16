extends CharacterBody2D


var speed = 300
var direction = 1
var triggered = false 
var reverseTrigger = false

func _physics_process(delta: float) -> void:
	velocity.x = direction * speed 
	velocity.y = 0
	
	
	move_and_slide()	

func _on_Plat_movebox_body_exited(body: Node2D) -> void:
	#print("hit")
	if body.name == "Plat" and reverseTrigger == false:
		#print(get_parent().name)
		speed = 300
		direction = direction * -1


func _on_Plat_2_body_exited(body: Node2D) -> void:
	if body.name=="Plat2":
		direction = direction * -1


func _on_Plat_3_body_exited(body: Node2D) -> void:
	if body.name=="Plat3":
		print("Plat3 exit")
		direction = direction * -1


func _on_faster_box_body_entered(body: Node2D) -> void:
	if body.name =="Player":
		speed = speed + 300
		print("fast time")


func _on_faster_box_body_exited(body: Node2D) -> void:
	if body.name =="Player":
		speed = 300
		print("slow time")
		
		


func _on_plat_player_entered(body: Node2D) -> void:
	if body.name =="Player": 
		print("player here")
		speed = 0
	


func _on_player_body_exited(body: Node2D) -> void:
	if body.name =="Player":
		speed = 500


func _on_appearing_2_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
