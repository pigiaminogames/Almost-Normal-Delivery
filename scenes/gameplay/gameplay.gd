extends Node2D

@onready var delivery_area: Area2D = $delivery_area
@onready var player: player_gd = $player
var t = 0

func _ready() -> void:
	change_delivery_area_pos()
	var scene_data = GGT.get_current_scene_data()
	print("GGT/Gameplay: scene params are ", scene_data.params)


	if GGT.is_changing_scene(): # this will be false if starting the scene with "Run current scene" or F6 shortcut
		await GGT.scene_transition_finished

	print("GGT/Gameplay: scene transition animation finished")


func _process(_delta):
	pass


func change_delivery_area_pos() -> void:
	var numr = (randi() % 10)
	
	match numr:
		0:
			delivery_area.global_position = Vector2(-32, 326)
			delivery_area.rotation = 0.0
		1:
			delivery_area.global_position = Vector2(392, 992)
			delivery_area.global_rotation = 1.57
		2:
			delivery_area.global_position = Vector2(1464, 1344)
			delivery_area.global_rotation = 1.57
		3:
			delivery_area.global_position = Vector2(766, 1616)
			delivery_area.global_rotation = 1.57
		4:
			delivery_area.global_position = Vector2(1232, 1777)
			delivery_area.rotation = 0.0
		5:
			delivery_area.global_position = Vector2(2144, 992)
			delivery_area.global_rotation = 1.57
		6:
			delivery_area.global_position = Vector2(3065, 984)
			delivery_area.global_rotation = 1.57
		7:
			delivery_area.global_position = Vector2(2912, 1344)
			delivery_area.global_rotation = 1.57
		8:
			delivery_area.global_position = Vector2(3472, 351)
			delivery_area.rotation = 0.0
		9:
			delivery_area.global_position = Vector2(1216, 464)
			delivery_area.global_rotation = 1.57
	
	print(numr)
	print(delivery_area.global_position)


func _on_delivery_area_body_entered(body: Node2D) -> void:
	if body == player:
		globalscript.point += 1
		change_delivery_area_pos()
