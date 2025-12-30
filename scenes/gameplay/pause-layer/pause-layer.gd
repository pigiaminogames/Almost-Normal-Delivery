extends CanvasLayer

@onready var pause := self
@onready var resume_option := $MarginContainer/Control/VBoxOptions/Resume
@onready var pause_options = $MarginContainer/Control/VBoxOptions
@onready var color_rect = $ColorRect
#@onready var gameplay_margin_container: MarginContainer = $gameplay_margin_container

@onready var points_panel_container: PanelContainer = $MarginContainer/Control/PanelContainer
@onready var malus_panel_container: PanelContainer = $PanelContainer2
@onready var timer_panel_conteiner: PanelContainer = $MarginContainer/Control/PanelContainer3

@onready var arrow_stackedsprite: stackedsprite = %arrow_stackedsprite
@onready var points_label: Label = $MarginContainer/Control/PanelContainer/MarginContainer2/points_label
@onready var timer_label: Label = $MarginContainer/Control/PanelContainer3/MarginContainer2/timer_label

#@onready var delivery_package_timer: Timer = $delivery_package_timer
@onready var actual_malus_label: Label = $PanelContainer2/MarginContainer/VBoxContainer/actual_malus_label


@onready var nodes_grp1 = [arrow_stackedsprite, points_panel_container, malus_panel_container, timer_panel_conteiner] # should be visible during gamemplay and hidden during pause
@onready var nodes_grp2 = [pause_options, color_rect] # should be visible only in pause menu


func _ready():
	pause_hide()


func pause_show():
	for n in nodes_grp1:
		n.hide()
	for n in nodes_grp2:
		n.show()


func pause_hide():
	for n in nodes_grp1:
		if n:
			n.show()

	for n in nodes_grp2:
		if n:
			n.hide()


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			resume()
		else:
			pause_game()
		get_viewport().set_input_as_handled()


func resume():
	get_tree().paused = false
	pause_hide()


func pause_game():
	resume_option.grab_focus()
	get_tree().paused = true
	pause_show()


func _on_Resume_pressed():
	resume()


func _on_main_menu_pressed():
	GGT.change_scene("res://scenes/menu/menu.tscn", {"show_progress_bar": false})


func _process(_delta: float) -> void:
	points_label.text = str(globalscript.point)
	timer_label.text = "Time: " + str(globalscript.delivery_timer)
	
	match globalscript.actual_malus:
		1:
			actual_malus_label.text = "WARNING: the package is havier"
		2:
			actual_malus_label.text = "WARNING: the road is slippey"
		3:
			actual_malus_label.text = "WARNING: the steering likes to change"
		4:
			actual_malus_label.text = "WARNING: the navigator is not functioning properly"
