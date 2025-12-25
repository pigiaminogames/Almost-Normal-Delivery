@tool
extends stackedsprite
class_name player_stackedsprite

@onready var car: player = $".."


func _process(_delta: float) -> void:
	global_rotation = 0
	
	
	for sprite in layers:
		sprite.global_rotation = car.global_rotation
		#print(sprite.global_rotation)
