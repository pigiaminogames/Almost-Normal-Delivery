extends CanvasLayer

@onready var pause := self
@onready var resume_option := $MarginContainer/Control/VBoxOptions/Resume
@onready var pause_options = $MarginContainer/Control/VBoxOptions
@onready var color_rect = $ColorRect
#@onready var gameplay_margin_container: MarginContainer = $gameplay_margin_container

@onready var points_panel_container: PanelContainer = $MarginContainer/Control/PanelContainer
@onready var malus_panel_container: PanelContainer = $MarginContainer/Control/PanelContainer2
@onready var timer_panel_conteiner: PanelContainer = $MarginContainer/Control/PanelContainer3
@onready var arrow_container: Container = $MarginContainer/Control/Container

@onready var arrow_stackedsprite: stackedsprite = $MarginContainer/Control/Container/arrow_stackedsprite
@onready var points_label: Label = $MarginContainer/Control/PanelContainer/points_label
@onready var timer_label: Label = $MarginContainer/Control/PanelContainer3/timer_label
#@onready var actual_malus_label: Label = %actual_malus_label

@onready var malus_1: TextureRect = $MarginContainer/Control/PanelContainer2/MarginContainer/VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer/TextureRect
@onready var malus_2: TextureRect = $MarginContainer/Control/PanelContainer2/MarginContainer/VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer2/TextureRect
@onready var malus_3: TextureRect = $MarginContainer/Control/PanelContainer2/MarginContainer/VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer3/TextureRect
@onready var malus_4: TextureRect = $MarginContainer/Control/PanelContainer2/MarginContainer/VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer4/TextureRect



@onready var nodes_grp1 = [arrow_container, points_panel_container, malus_panel_container, timer_panel_conteiner] # should be visible during gamemplay and hidden during pause
@onready var nodes_grp2 = [pause_options, color_rect] # should be visible only in pause menu


func _ready():
	pause_hide()
	
	step_malus_atlas(malus_1)
	step_malus_atlas(malus_2)
	step_malus_atlas(malus_3)
	step_malus_atlas(malus_4)


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

func step_malus_atlas(texture: TextureRect) -> void:
	var original_tex := texture.texture
	
	if original_tex and not original_tex is AtlasTexture:
		var atlas = AtlasTexture.new()
		atlas.atlas = original_tex
		atlas.region = Rect2(0, 0, 16, 16)
		texture.texture = atlas


func _process(_delta: float) -> void:
	points_label.text = str(globalscript.point)
	timer_label.text = "Time: " + str(int(globalscript.delivery_timer))
	
	reset_malus_icon()
	
	match globalscript.actual_malus:
		1:
			set_icon_active(malus_1, true)
			#actual_malus_label.text = "WARNING: the package is havier"
		2:
			set_icon_active(malus_2, true)
			#actual_malus_label.text = "WARNING: the road is slippey"
		3:
			set_icon_active(malus_3, true)
			#actual_malus_label.text = "WARNING: the steering likes to change"
		4:
			set_icon_active(malus_4, true)
			#actual_malus_label.text = "WARNING: the navigator is not functioning properly"


func reset_malus_icon() -> void:
	set_icon_active(malus_1, false)
	set_icon_active(malus_2, false)
	set_icon_active(malus_3, false)
	set_icon_active(malus_4, false)


func set_icon_active(texture: TextureRect, active: bool) -> void:
	if texture.texture is AtlasTexture:
		texture.texture.region.position.x = 16 if active else 0
