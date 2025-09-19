extends CharacterBody2D


const speed = 2
const JUMP_VELOCITY = -400.0
@export var rotation_speed = 1.5
var orbit_angle_offset
var rotation_direction = 1

var deg=0
func _process(delta: float) -> void:
	if find_children("SawRev"):
		rotation_direction = -1
	rotate(rotation_direction*speed*delta)
	



		
