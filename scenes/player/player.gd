extends CharacterBody2D

@onready var sprite: Sprite2D = $stackedsprite2D


@export var acceleration := 250.0
@export var max_speed := 800.0
@export var friction := 600.0
@export var turn_speed := 1.5

var speed := 0.0


func _physics_process(delta: float) -> void:
	handle_input(delta)
	apply_friction(delta)
	move_car(delta)
	
	move_and_slide()


func handle_input(delta) -> void:
	var turn
	
		#sprite.rotate_sprite()
	
	
	if Input.is_action_pressed("key_up"):
		speed += acceleration * delta
		turn = Input.get_axis("key_left", "key_right")
	elif Input.is_action_pressed("key_down"):
		speed -= acceleration * delta
		turn = Input.get_axis("key_right", "key_left")
	
	if Input.is_action_pressed("key_up") or Input.is_action_pressed("key_down"):
		rotation += turn * turn_speed * delta
	
	speed = clamp(speed, -max_speed * 0.5, max_speed)
	


func apply_friction(delta) -> void:
	if not Input.is_action_pressed("key_up") and not Input.is_action_pressed("key_down"):
		speed = move_toward(speed, 0, friction * delta)
	


func move_car(_delta) -> void:
	velocity = -transform.y * speed
	print(velocity)
