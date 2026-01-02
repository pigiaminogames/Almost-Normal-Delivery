extends Control

@onready var btn_play = $CanvasLayer/MarginContainer/Control/VBoxContainer/PlayButton
@onready var btn_exit = $CanvasLayer/MarginContainer/Control/VBoxContainer/ExitButton
@onready var camera: Camera2D = $player/Camera2D
@onready var player: player_gd = $player


func _ready():
	# needed for gamepads to work
	btn_play.grab_focus()
	if OS.has_feature('web'):
		btn_exit.queue_free() # exit button dosn't make sense on HTML5
	
	globalscript.is_game_active = false
	globalscript.actual_malus = -1
	globalscript.weight_malus = 0.8
	globalscript.actual_slippery_factor = 0.1 
	#camera.global_position.y = player.global_position.y + n


func _on_PlayButton_pressed() -> void:
	var params = {
		"show_progress_bar": true,
		"a_number": 10,
		"a_string": "Ciao!",
		"an_array": [1, 2, 3, 4],
		"a_dict": {
			"name": "test",
			"val": 15
		},
	}
	globalscript.is_game_active = true
	GGT.change_scene("res://scenes/gameplay/gameplay.tscn", params)


func _on_ExitButton_pressed() -> void:
	# gently shutdown the game
	var transitions = get_node_or_null("/root/GGT_Transitions")
	if transitions:
		transitions.fade_in({
			'show_progress_bar': false
		})
		await transitions.anim.animation_finished
		await get_tree().create_timer(0.3).timeout
	get_tree().quit()


#func _process(delta: float) -> void:
	#camera.global_position.y = player.global_position.y + n
