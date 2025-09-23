extends CharacterBody2D
class_name Enemy


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

#movement
var _DEFAULT_DIRECTION: Vector2 = Vector2.RIGHT
@export var _SPEED: float = 50

var _direction: Vector2 = _DEFAULT_DIRECTION
var _new_direction: Vector2

var _x: float
var _y: float
var _previous_position: Vector2


func _ready() -> void:
	_x = position.x
	_y = position.y


func _process(_delta: float) -> void:
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
	
	var _path: PackedVector2Array = _game.get_shortest_path(position, _pacman.position)
	
	if _path.size() >= 2:
		_new_direction = (_path[1] - global_position).normalized()
	else:
		_new_direction = Vector2.ZERO
	
	if _new_direction == Vector2.UP or _new_direction == Vector2.DOWN or _new_direction == Vector2.LEFT or _new_direction == Vector2.RIGHT:
		_direction = _new_direction
	
	velocity = _direction * _SPEED
	look_at(global_position + _direction)
	
	move_and_slide()
