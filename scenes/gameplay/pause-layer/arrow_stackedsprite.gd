@tool
extends stackedsprite

@onready var delivery_area: Area2D = $"../../../../../delivery_area"

@onready var flickering_timer := 0.0
@onready var invisible_timer := 0.0
@onready var flickering_threshhold := 0.0
@onready var flickering_time := 0.0
@onready var flickering_speed := 0.1


func _process(delta: float) -> void:
	global_rotation = 0
	
	
	if not is_instance_valid(delivery_area):
		return
	else:
		var should_be_visible := true
		
		if invisible_timer > 0.0:
			should_be_visible = false
		elif flickering_timer > 0.0 and flickering_timer <= flickering_threshhold:
			flickering_time += delta
				
			if flickering_time > flickering_speed:
				flickering_time = 0.0
			should_be_visible = (int(Time.get_ticks_msec() / 100)) % 2 == 0
		
		visible = should_be_visible

		
		var cam = get_viewport().get_camera_2d()
		
		var delivery_area_pos = delivery_area.global_position
		if not is_instance_valid(cam):
			return
		var cam_pos = cam.global_position
	
		var direction = delivery_area_pos - cam_pos
		var direction_angle = direction.angle()
	
	#direction_angle += PI/2
		for sprite in layers:
			if is_instance_valid(sprite):
				sprite.rotation = direction_angle


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	if not is_instance_valid(globalscript): return
	
	if globalscript.actual_malus == 4:
		if flickering_timer == 0.0 and invisible_timer == 0.0:
			start_flickering_timer()
		elif flickering_timer > 0.0:
			flickering_timer -= delta
			#print("ft: " + str(flickering_timer))
			
			if flickering_timer <= 0.0:
				start_invisible_timer()
		elif invisible_timer > 0.0:
			#print("it: " + str(invisible_timer))
			invisible_timer -= delta
			
			if invisible_timer <= 0.0:
				start_flickering_timer()
	else:
		flickering_timer = 0.0
		invisible_timer = 0.0
		visible = true


func start_invisible_timer() -> void:
	flickering_timer = 0.0
	invisible_timer = globalscript.no_arrow_timer
	
	#print("it: " + str(invisible_timer))


func start_flickering_timer() -> void:
	invisible_timer = 0.0

	flickering_timer = randf_range(globalscript.min_sec_no_arrow_timer, globalscript.max_sec_no_arrow_timer)
	flickering_threshhold = 0.25 * flickering_timer
	
	#print("ft: " + str(flickering_timer))
