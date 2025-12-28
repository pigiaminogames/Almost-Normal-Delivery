@tool
extends stackedsprite

@onready var delivery_area: Area2D = $"../../../../../delivery_area"


func _process(_delta: float) -> void:
	global_rotation = 0
	
	
	if not is_instance_valid(delivery_area):
		return
	else:
		var cam = get_viewport().get_camera_2d()
		
		var delivery_area_pos = delivery_area.global_position
		var cam_pos = cam.global_position
	
		var direction = delivery_area_pos - cam_pos
		var direction_angle = direction.angle()
	
	#direction_angle += PI/2
	
		visible = true
		for sprite in layers:
			if is_instance_valid(sprite):
				sprite.rotation = direction_angle
