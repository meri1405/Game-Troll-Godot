extends Area2D

@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var pickup_player: AudioStreamPlayer2D = $Pickup

@export var gai_path: NodePath  # Kéo thả Gai từ Inspector vào

var triggered: bool = false
var start_position: Vector2

func _ready():
	sprite_2d.play("default")
	start_position = global_position
	show()
	collision.disabled = false

	# Đảm bảo Gai ban đầu ẩn
	if gai_path != null:
		var gai = get_node(gai_path)
		_hide_gai(gai)


func _on_body_entered(body):
	if body.is_in_group("Player"):
		if pickup_player:
			pickup_player.play()
		hide()
		collision.disabled = true
		body.die()

		# Hiện Gai trong 0.2 giây
		if gai_path != null:
			_trigger_gai()


func _on_saw_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Saw activated!")
		triggered = true


func reset_trap():
	global_position = start_position
	show()
	collision.disabled = false
	triggered = false

	if gai_path != null:
		var gai = get_node(gai_path)
		_hide_gai(gai)


# ==============================
# HÀM HỖ TRỢ
# ==============================
func _trigger_gai():
	var gai = get_node(gai_path)
	var gai_collision = gai.get_node("CollisionShape2D")
	var gai_anim = gai.get_node("AnimatedSprite2D")

	# Hiện Gai + bật animation
	gai.show()
	gai_collision.disabled = false
	gai_anim.play("default")  # hoặc "attack" tùy bạn đặt tên trong Sprite

	# Sau 0.2s thì ẩn
	await get_tree().create_timer(0.4).timeout
	_hide_gai(gai)


func _hide_gai(gai: Node):
	var gai_collision = gai.get_node("CollisionShape2D")
	var gai_anim = gai.get_node("AnimatedSprite2D")

	gai.hide()
	gai_collision.disabled = true
	gai_anim.stop()
