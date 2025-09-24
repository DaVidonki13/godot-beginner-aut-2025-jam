extends Node2D


@onready var countdown_sfx: Timer = %countdown_sfx
@onready var sfx_1: AudioStreamPlayer2D = %sfx_1
@onready var sfx_2: AudioStreamPlayer2D = %sfx_2
@onready var sfx_3: AudioStreamPlayer2D = %sfx_3

var random: RandomNumberGenerator = RandomNumberGenerator.new()


#func _process(_delta: float) -> void:
	#print(countdown_sfx.time_left)


func _on_countdown_sfx_timeout() -> void:
	#var numr = (randi() % 4 + 1)
	#if numr == 1:
		#sfx_1.play()
	#elif numr == 2:
		#sfx_2.play()
	#else:
		#sfx_3.play()
	
	sfx_1.play()
