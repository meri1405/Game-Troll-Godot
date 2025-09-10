extends Node2D

@export var mute: bool = false

func _ready() -> void:
	if not mute:
		play_music()
		

func play_click() -> void:
	if not mute and $Click.stream:
		$Click.loop = true       
		$Click.play()

# Phát nhạc nền
func play_music() -> void:
	if not mute and $Music.stream:
		$Music.loop = true       # lặp nhạc nền
		$Music.play()

# Phát âm thanh nhảy
func play_jump() -> void:
	if not mute and $Jump.stream:
		$Jump.play()

# Phát nhạc kết thúc level
func play_end_game() -> void:
	if not mute:
		$Music.stop()
		if $Endgame.stream:
			$Endgame.play()
