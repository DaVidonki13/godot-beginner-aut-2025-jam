extends CharacterBody2D
class_name Player


#raycast
@onready var _raycast_up: RayCast2D = %raycast_up
@onready var _raycast_down: RayCast2D = %raycast_down
@onready var _raycast_right: RayCast2D = %raycast_right
@onready var _raycast_left: RayCast2D = %raycast_left

@onready var _raycast_front: RayCast2D = %raycast_front
#@onready var _raycast_back: RayCast2D = %raycast_back
#@onready var _raycast_east: RayCast2D = %raycast_east
#@onready var _raycast_west: RayCast2D = %raycast_west

#sprite
@onready var _animated_sprite: AnimatedSprite2D = $animated_sprite

#movement
var _DEFAULT_DIRECTION: Vector2 = Vector2.RIGHT
@export var _SPEED: float = 50

var _direction: Vector2 = _DEFAULT_DIRECTION
var _new_direction: Vector2 = _DEFAULT_DIRECTION

var _x: float
var _y: float
var _previous_position: Vector2

#input
#const _DELETE_INPUT_TIMER_LENGHT: float = 4
#var _delete_input_timer: float = 0


func _ready() -> void:
	_x = position.x
	_y = position.y


func _process(_delta: float) -> void:
	#animation
	if velocity == Vector2.ZERO:
		_animated_sprite.pause() #idle
	else:
		_animated_sprite.play("walk")
	
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
		
		if _new_direction == Vector2.UP and not _raycast_up.is_colliding():
			_direction = _new_direction
		elif _new_direction == Vector2.DOWN and not _raycast_down.is_colliding():
			_direction = _new_direction
		elif _new_direction == Vector2.LEFT and not _raycast_left.is_colliding():
			_direction = _new_direction
		elif _new_direction == Vector2.RIGHT and not _raycast_right.is_colliding():
			_direction = _new_direction
	
	if _raycast_front.is_colliding(): #can be improved
		_direction = Vector2.ZERO
		if _new_direction == Vector2.UP and not _raycast_up.is_colliding():
			_direction = _new_direction
		elif _new_direction == Vector2.DOWN and not _raycast_down.is_colliding():
			_direction = _new_direction
		elif _new_direction == Vector2.LEFT and not _raycast_left.is_colliding():
			_direction = _new_direction
		elif _new_direction == Vector2.RIGHT and not _raycast_right.is_colliding():
			_direction = _new_direction
	
	#input
	if Input.is_action_just_pressed("pacman_up"):
		_new_direction = Vector2.UP
	elif Input.is_action_just_pressed("pacman_down"):
		_new_direction = Vector2.DOWN
	elif Input.is_action_just_pressed("pacman_left"):
		_new_direction = Vector2.LEFT
	elif Input.is_action_just_pressed("pacman_right"):
		_new_direction = Vector2.RIGHT
	#delede input after _DELETE_INPUT_TIMER_LENGHT
	#else:
		#if _delete_input_timer > _DELETE_INPUT_TIMER_LENGHT:
			#_new_direction = Vector2.ZERO
			#_delete_input_timer = 0
	#_delete_input_timer += _delta
	
	velocity = _direction * _SPEED
	look_at(position + _direction)
	
	_animated_sprite.position = position
	if _direction == Vector2.LEFT:
		_animated_sprite.flip_h = true
	elif _direction == Vector2.RIGHT:
		_animated_sprite.flip_h = false
	
	if _animated_sprite.flip_h:
		_animated_sprite.offset.x = -30
	else:
		_animated_sprite.offset.x = -18
	
	move_and_slide()
