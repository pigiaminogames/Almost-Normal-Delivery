extends Node2D

@onready var delivery_area: Area2D = $delivery_area
@onready var player: player_gd = $player

@onready var change_malus_audio: AudioStreamPlayer = $audio/change_malus_audio
@onready var more_difficult_audio: AudioStreamPlayer = $audio/more_difficult_audio


var t = 0
var numr: int = -1

func _ready() -> void:
	get_tree().paused = false
	var scene_data = GGT.get_current_scene_data()
	print("GGT/Gameplay: scene params are ", scene_data.params)

	if GGT.is_changing_scene(): # this will be false if starting the scene with "Run current scene" or F6 shortcut
		await GGT.scene_transition_finished

	print("GGT/Gameplay: scene transition animation finished")
	
	globalscript.is_game_active = true
	
	change_delivery_area_pos()
	change_malus()
	
	globalscript.point = 0
	globalscript.delivery_timer = 30.0
	
	globalscript.more_difficult_sound.connect(more_difficult)


#func _process(_delta):
	#if Input.is_action_just_pressed("ggt_debug_step_frame"):
		#globalscript.point += 1


func change_delivery_area_pos() -> void:
	var numr_b := (randi() % 10)
	
	while(numr_b == numr):
		numr_b = (randi() % 10)
	
	numr = numr_b
	
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
	
	print("Delivery area pos: " + str(numr))
	print(delivery_area.global_position)


func change_malus() -> void:
	var random_malus := (randi() % 4 + 1)
	
	while(random_malus == globalscript.actual_malus):
		random_malus = (randi() % 4 + 1)
	
	#var random_malus := 3
	
	globalscript.actual_malus = random_malus
	
	print("Actual malus: " + str(globalscript.actual_malus))
	change_malus_audio.pitch_scale = randf_range(0.85, 1.15)
	change_malus_audio.play()


func _on_delivery_area_body_entered(body: Node2D) -> void:
	if body == player:
		globalscript.point += 1
		globalscript.delivery_timer = 30.0
		change_delivery_area_pos()
		change_malus()


func _on_pause_layer_restart() -> void:
	get_tree().reload_current_scene()


func more_difficult() -> void:
	more_difficult_audio.pitch_scale = randf_range(0.85, 1.15)
	more_difficult_audio.play()
