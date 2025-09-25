extends Area2D

@export var teleport_main: Node2D   # Kéo TeleportMain vào đây trong Inspector

func _ready():
	if teleport_main:
		teleport_main.hide()              # Ẩn teleport ban đầu
		teleport_main.modulate.a = 0.0    # Trong suốt hoàn toàn

	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("Player") and teleport_main:
		teleport_main.show()   # Bật teleport lên
		var tween = create_tween()
		tween.tween_property(teleport_main, "modulate:a", 1.0, 1.0) # fade in 1s
		# Nếu muốn ShowTeleMain chỉ kích hoạt 1 lần thì ẩn nó đi
		hide()
