extends Node2D

@onready var volume
@onready var pan

@onready var countdown_sfx: Timer = %countdown_sfx
@onready var sfx_1: AudioStreamPlayer2D = %sfx_1
@onready var sfx_2: AudioStreamPlayer2D = %sfx_2
@onready var sfx_3: AudioStreamPlayer2D = %sfx_3
@onready var player: CharacterBody2D = $"../pacman"

@export var max_distance: float = 600.0
@export var min_distance: float = 50.0

@onready var sfx_array = [sfx_1, sfx_2, sfx_3]

var random: RandomNumberGenerator = RandomNumberGenerator.new()


func _process(_delta: float) -> void:
	var rel_pos = global_position - player.global_position
	var dist = rel_pos.length()
	
	volume = clamp(1.0 - (dist - min_distance) / (max_distance - min_distance), 0.0, 1.0)
	position = Vector2(global_position.x, player.global_position.y)
	
	print(countdown_sfx.time_left)


func _on_countdown_sfx_timeout() -> void:
	var numr = (randi() % 3)
	
	sfx_array[numr].volume_db = linear_to_db(volume)
	sfx_array[numr].position = position
	sfx_array[numr].play()
	
