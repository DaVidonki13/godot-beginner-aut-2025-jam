extends CharacterBody2D
class_name Enemy

#TODO aggiungere jumpscare : davide
#TODO aggiungere rumore nemico vicino: davide


@export var _enemy_type: int

#main
@onready var _game: Game = $".."
@onready var _pacman: Player = %pacman

#raycast
@onready var _raycast_up: RayCast2D = %raycast_up
@onready var _raycast_down: RayCast2D = %raycast_down
@onready var _raycast_right: RayCast2D = %raycast_right
@onready var _raycast_left: RayCast2D = %raycast_left

#@onready var _raycast_front: RayCast2D = %raycast_front
##@onready var _raycast_back: RayCast2D = %raycast_back
#@onready var _raycast_east: RayCast2D = %raycast_east
#@onready var _raycast_west: RayCast2D = %raycast_west

#sprite
@onready var _sprite: Sprite2D = %sprite

#movement
var _DEFAULT_DIRECTION: Vector2 = Vector2.RIGHT
@export var _SPEED: float = 40

var _direction: Vector2 = _DEFAULT_DIRECTION
var _new_direction: Vector2

var _x: float
var _y: float
var _previous_position: Vector2

#enemy logic
var _stopwatch: float = 0
var _seed: int = 0


func _ready() -> void:
	_x = position.x
	_y = position.y


func _process(_delta: float) -> void:
	_stopwatch += _delta
	
	_sprite.position = position
	
	var _front: Vector2 = Vector2.RIGHT.rotated(rotation)
	var _back: Vector2 = _front.rotated(PI)
	var _east: Vector2 = _front.rotated(-PI/2)
	var _west: Vector2 = _front.rotated(PI/2)
	
	_raycast_up.position = position
	_raycast_down.position = position
	_raycast_right.position = position
	_raycast_left.position = position
	
	_x += position.x - _previous_position.x
	_y += position.y - _previous_position.y
	_previous_position = position
	if _x >= 16 or _y >= 16 or _x <= -16 or _y <= -16:
		_x = 0
		_y = 0
		position = Vector2(snapped(position.x, 8), snapped(position.y, 8))
	
	var _target_position: Vector2 = _find_target_position()
	var _path: PackedVector2Array = _game.get_shortest_path(position, _target_position)
	
	if _path.size() >= 2:
		_new_direction = (_path[1] - global_position).normalized()
	else:
		_new_direction = Vector2.ZERO
	
	if _new_direction == Vector2.UP or _new_direction == Vector2.DOWN or _new_direction == Vector2.LEFT or _new_direction == Vector2.RIGHT:
		_direction = _new_direction
	
	velocity = _direction * _SPEED
	look_at(global_position + _direction)
	
	move_and_slide()


func _find_target_position() -> Vector2:
	if (position - _pacman.position).length() < 120: #if near pacman chase pacman
		return _pacman.position
	else:
		match _enemy_type:
			1:
				return _pacman.position
			2:
				return _pacman.position + Vector2.RIGHT.rotated(rotation) * 100
			3:
				return _pacman.position + _pacman.get_front_direction() * 100
			4:
				return _pacman.position + _pacman.get_front_direction() * -100
			5:
				if _stopwatch > 10:
					_stopwatch = 0
					_seed += 1
				seed(_seed)
				return Vector2(randf_range(-440, 440), randf_range(-408.0, 408.0))
			_:
				push_error(_enemy_type, " not a valid enemy type")
				return Vector2.ZERO
