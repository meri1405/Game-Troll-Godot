extends Node2D

@export var mute: bool = false

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

# Phát âm thanh bước chân (loop khi chạy)
func play_walk() -> void:
	if not mute and not $Walk.playing:
		$Walk.play()

# Dừng âm thanh bước chân
func stop_walk() -> void:
	if $Walk.playing:
		$Walk.stop()

# Phát âm thanh khi lên level
func play_level_up() -> void:
	if not mute:
		$LevelUp.play()

func play_checkpoint() -> void:
	if not mute:
		$checkpoint.play()

func play_respawn() -> void:
	if not mute:	
		$Respawn.play()

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
	
