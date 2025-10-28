extends Node2D

@export var mute: bool = false
<<<<<<< HEAD
@export var is_chasing: bool = false


func _ready():
	if not mute:
		play_music()

# Phát nhạc nền
func play_music():
	if not mute:
		$Music.play()

# Phát âm thanh khi nhảy
func play_jump() -> void:
	if not mute:
		$Jump.play()

# Phát âm thanh click
func play_click() -> void:
	if not mute:
		$Click.play()

# Kết thúc màn chơi (dừng nhạc, phát end game)
func play_end_level() -> void:
	if not mute:
		$Music.stop()
		$EndLevel.play()

# Dừng tất cả âm thanh
func stop_all() -> void:
	$Music.stop()
	$Jump.stop()
	$Click.stop()
	$EndLevel.stop()
	
=======

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
>>>>>>> 8cbdea131be2545ac35de74fe103be710b14221a
