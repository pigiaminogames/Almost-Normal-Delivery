extends CharacterBody2D
class_name player_gd


@export_category("Car_Velocity")
@export var acceleration := 250.0
@export var max_speed := 800.0
@export var friction := 600.0
@export var turn_speed := 1.5

var speed := 0.0

@onready var stack_root: player_stackedsprite = $player_stackedsprite
var sprites = []

@onready var orientated := 0


func _ready() -> void:
	global_rotation = 1.57


func _physics_process(delta: float) -> void:
	handle_input(delta)
	apply_friction(delta)
	move_car(delta)
	
	move_and_slide()
	
	update_stack()
	#print(orientated)


func handle_input(delta) -> void:
	var turn
	
		#sprite.rotate_sprite()
	
	
	if Input.is_action_pressed("key_up"):
		speed += acceleration * delta
		turn = Input.get_axis("key_left", "key_right")
		#if orientated == 0:
			#orientated = 1
			#turn = Input.get_axis("key_left", "key_right")
	elif Input.is_action_pressed("key_down"):
		speed -= acceleration * delta
		turn = Input.get_axis("key_right", "key_left")
		#if orientated == 0:
			#orientated = -1
			#turn = Input.get_axis("key_right", "key_left")
	
	if Input.is_action_pressed("key_up") or Input.is_action_pressed("key_down"):
		
		rotation += turn * turn_speed * delta
	
	speed = clamp(speed, -max_speed * 0.5, max_speed)
	
	#TODO RISOLVERE PROBLEMA MACCHINA CHE GIRA A VELOCITÀ TROPPO PICCOLE O AL CONTRARIO



func apply_friction(delta) -> void:
	if not Input.is_action_pressed("key_up") and not Input.is_action_pressed("key_down"):
		speed = move_toward(speed, 0, friction * delta)
		
		
	


func move_car(_delta) -> void:
	velocity = -transform.y * speed
	#print(velocity)


func update_stack() -> void:
	var angle := rotation
	
	for i in range(sprites.size()):
		var sprite = sprites[i]
		var height := i * 4
		
		sprite.position.x = sin(angle) * height
		sprite.position.y = -height
		sprite.z_index = i
