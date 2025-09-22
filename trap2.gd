extends Node2D

var wave_distance = 100.0

@onready var area := $top2_dect
@onready var tween := get_tree().create_tween()

func _ready():
	if area:
		area.body_entered.connect(_on_body_entered)
	else:
		print("Không tìm thấy node 'top2_dect'!")

func _on_body_entered(body):
	if body.name == "player":
		var positions = [Vector2(0, 0), Vector2(0, wave_distance), Vector2(0, 0), Vector2(0, wave_distance)]
		for pos in positions:
			tween.tween_property(area, "position", pos, 1.0)
