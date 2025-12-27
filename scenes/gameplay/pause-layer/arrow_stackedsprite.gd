@tool
extends stackedsprite

@onready var delivery_area: Area2D = $"../../../../delivery_area"


func _process(_delta: float) -> void:
	global_rotation = 0
	
	if not is_instance_valid(delivery_area):
		return
	
	var cam = get_viewport().get_camera_2d()
	
	var direction = delivery_area.global_position - cam.global_position
	var direction_angle = direction.angle()
	
	#direction_angle += PI/2
	
	for sprite in layers:
		sprite.rotation = direction_angle
