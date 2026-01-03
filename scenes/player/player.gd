extends CharacterBody2D
class_name player_gd


@export_category("Car_Velocity")
@export var acceleration := 250.0
@export var max_speed := 800.0
@export var friction := 600.0
@export var turn_speed := 1.5

@export_category("Slippery_Settings")
@export var base_traction := 10.0

var speed := 0.0

@onready var stack_root: player_stackedsprite = $player_stackedsprite
var sprites = []

@onready var arrow: Sprite2D = $arrow

@onready var orientated := 0

@onready var wait_inverted_arrow_timer := 0.0
@onready var inverted_arrow_timer := 0.0

@onready var hurt_audio: AudioStreamPlayer2D = $audio/hurt_audio
@onready var change_direction_sound: AudioStreamPlayer2D = $audio/change_direction_sound
@onready var car_sound: AudioStreamPlayer = $audio/car_sound

@export_category("Trail")
@export var trail: PackedScene
@onready var trail_pos: Marker2D = $Trail_pos
@onready var trail_pos_2: Marker2D = $Trail_pos_2
var current_skid_l: Line2D
var current_skid_r: Line2D
var is_turning := false

@onready var coutdown_timer := false


func _ready() -> void:
	global_rotation = 1.57
	arrow.hide()


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	if not is_instance_valid(globalscript): return
	
	if globalscript.actual_malus == 3:
		if wait_inverted_arrow_timer == 0.0 and inverted_arrow_timer == 0.0:
			start_wait_inverted_timer()
		elif wait_inverted_arrow_timer > 0.0:
			wait_inverted_arrow_timer -= delta
			
			if wait_inverted_arrow_timer <= 0.0:
				start_inverted_timer()
		elif inverted_arrow_timer > 0.0:
			inverted_arrow_timer -= delta
			
			if inverted_arrow_timer <= 0.0:
				start_wait_inverted_timer()
	else:
		wait_inverted_arrow_timer = 0.0
		inverted_arrow_timer = 0.0
	
	if coutdown_timer:
		handle_input(delta)
		apply_friction(delta)
		move_car(delta)
	
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		speed = velocity.dot(-transform.y)
	
	update_stack()
	update_car_sound()
	#print(orientated)


#func _process(_delta: float) -> void:
	#if velocity != Vector2.ZERO:
		#car_sound.play()
		#await car_sound.finished
	#else:
		#car_sound.stop()


func handle_input(delta) -> void:
	var turn: float = 0.0
	
		#sprite.rotate_sprite()
	
	
	if Input.is_action_pressed("key_up"):
		speed += acceleration * delta
		#turn = Input.get_axis("key_left", "key_right")
		#if orientated == 0:
			#orientated = 1
			#turn = Input.get_axis("key_left", "key_right")
	elif Input.is_action_pressed("key_down"):
		speed -= friction * delta
		#turn = Input.get_axis("key_right", "key_left")
		#if orientated == 0:
			#orientated = -1
			#turn = Input.get_axis("key_right", "key_left")
	
	speed = clamp(speed, -max_speed * 0.5, max_speed)
	#print(speed)
	
	var direction_factor: int = 0
	
	if speed > 30:
		direction_factor = 1
	elif speed < -10:
		direction_factor = -1
	
	if direction_factor != 0:
		var input_turn = Input.get_axis("key_left", "key_right")
		
		if globalscript.actual_malus == 3:
			if inverted_arrow_timer > 0.0:
				turn = Input.get_axis("key_right", "key_left")
				arrow.show()
			elif wait_inverted_arrow_timer > 0.0:
				turn = input_turn
				arrow.hide()
		else:
			turn = input_turn
			arrow.hide()
		
		rotation += turn * turn_speed * delta * direction_factor
		
		if abs(turn) > 0.1 and velocity.length() > 50.0:
			if not is_turning:
				start_skid()
			update_skid()
		else:
			if is_turning:
				stop_skid()
	else:
		if is_turning:
			stop_skid()


func start_skid() -> void:
	is_turning = true
	
	if trail:
		current_skid_l = trail.instantiate()
		current_skid_r = trail.instantiate()
		
		get_tree().current_scene.add_child(current_skid_l)
		get_tree().current_scene.add_child(current_skid_r)
		
		var alpha_boost := 1.0
		if globalscript.actual_malus == 2:
			alpha_boost = 1.0 + globalscript.actual_slippery_factor
		
		current_skid_l.modulate.a *= alpha_boost
		current_skid_r.modulate.a *= alpha_boost


func update_skid() -> void:
	if is_instance_valid(current_skid_l):
		current_skid_l.add_point(trail_pos.global_position)
	if is_instance_valid(current_skid_r):
		current_skid_r.add_point(trail_pos_2.global_position)
	
	if current_skid_l and current_skid_l.get_point_count() > 100:
		current_skid_l.remove_point(0)
	if current_skid_r and current_skid_r.get_point_count() > 100:
		current_skid_r.remove_point(0)


func stop_skid() -> void:
	is_turning = false
	
	if is_instance_valid(current_skid_l) and current_skid_l.has_method("stop_drawing"):
		current_skid_l.stop_drawing()
	if is_instance_valid(current_skid_r) and current_skid_r.has_method("stop_drawing"):
		current_skid_r.stop_drawing()
	
	current_skid_l = null
	current_skid_r = null


func apply_friction(delta) -> void:
	if not Input.is_action_pressed("key_up") and not Input.is_action_pressed("key_down"):
		speed = move_toward(speed, 0, friction * delta)	


func move_car(delta) -> void:
	var desired_velocity := -transform.y * speed
	
	if globalscript.actual_malus == 1:
		desired_velocity *= globalscript.weight_malus
	
	if globalscript.actual_malus == 2:
		var current_traction = lerp(base_traction, 0.5, globalscript.actual_slippery_factor)
		#print(current_traction)
		
		velocity = velocity.lerp(desired_velocity, current_traction * delta)
	else:
		velocity = velocity.lerp(desired_velocity, base_traction * delta)
	#print(velocity)


func update_stack() -> void:
	var angle := rotation
	
	for i in range(sprites.size()):
		var sprite = sprites[i]
		var height := i * 4
		
		sprite.position.x = sin(angle) * height
		sprite.position.y = -height
		sprite.z_index = i


func update_car_sound() -> void:
	var current_speed := velocity.length()
	
	if current_speed > 5.0:
		if !car_sound.playing:
			car_sound.play()
		
		car_sound.pitch_scale = clamp(1.0 + (current_speed / 500.0), 1.0, 2.5)
		
		car_sound.volume_db = lerp(-20.0, 0.0, current_speed / 300.0)
	else:
		car_sound.pitch_scale = 0.8


func start_inverted_timer() -> void:
	change_direction_sound.pitch_scale = randf_range(0.85, 1.15)
	change_direction_sound.play()
	wait_inverted_arrow_timer = 0.0
	inverted_arrow_timer = globalscript.inverted_arrow_timer


func start_wait_inverted_timer() -> void:
	change_direction_sound.pitch_scale = randf_range(0.85, 1.15)
	change_direction_sound.play()
	inverted_arrow_timer = 0.0
	wait_inverted_arrow_timer = randf_range(globalscript.min_sec_inverted_arrow_timer, globalscript.max_sec_inverted_arrow_timer)


func _on_gameplay_timer_finished() -> void:
	coutdown_timer = true
