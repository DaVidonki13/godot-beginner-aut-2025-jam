extends Node2D

@onready var pacman: CharacterBody2D = $pacman

func _on_r_area_2d_area_entered(_area: Area2D) -> void:
	pacman.global_position = Vector2(-414, 24)
	


func _on_l_area_2d_2_area_entered(_area: Area2D) -> void:
	pacman.global_position = Vector2(400, 24)
