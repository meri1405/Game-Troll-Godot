extends Control

@onready var death_count_label = $HBoxContainer/DeathCountLabel

func _ready():
	# Cập nhật death count ban đầu
	update_death_count(GameManager.get_death_count())
	
	# Lắng nghe signal khi death count thay đổi
	GameManager.death_count_changed.connect(_on_death_count_changed)

func _on_death_count_changed(new_count: int):
	update_death_count(new_count)

func update_death_count(count: int):
	death_count_label.text = "Deaths: " + str(count)