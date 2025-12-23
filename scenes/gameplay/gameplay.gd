extends Node2D



var t = 0

func _ready() -> void:
	var scene_data = GGT.get_current_scene_data()
	print("GGT/Gameplay: scene params are ", scene_data.params)


	if GGT.is_changing_scene(): # this will be false if starting the scene with "Run current scene" or F6 shortcut
		await GGT.scene_transition_finished

	print("GGT/Gameplay: scene transition animation finished")


func _process(_delta):
	pass
