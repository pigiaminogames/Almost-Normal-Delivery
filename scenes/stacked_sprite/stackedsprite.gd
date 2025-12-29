@tool
extends Node2D
class_name stackedsprite

@export_category("Settings")
@export var texture: Texture2D
@export var sprite_hframes := 10
@export var vertical_spacing := 1.0

@export_category("Rotation & Animation")
@export var sprite_rotation := 0.0
@export var spin_sprite := false
@export var spin_speed := 1.0

@export_category("LOD Optimization")
@export var lod_enabled := true
@export var dist_medium_quality := 600.0
@export var dist_low_quality := 1200.0

var spin_rotation_value := 0.0



@warning_ignore("unused_private_class_variable")
@export_tool_button("Stack Sprite!") var _restack_button: Callable = func():
	stack_sprites()

var layers: Array[Sprite2D] = []

#TODO RISOLVERE PROBLEMA Z-INDEX TRA EDIFICI (gemini)

func _ready() -> void:
	stack_sprites()
	update_layers_transform(1)


func _process(_delta: float) -> void:
	var render_step: int = 1 
	
	if lod_enabled:
		var cam = get_viewport().get_camera_2d()
		if cam:
			var dist = global_position.distance_to(cam.global_position)
			
			if dist > dist_low_quality:
				render_step = 4 # Qualità Bassa (Disegna il 25% delle fette)
			elif dist > dist_medium_quality:
				render_step = 2 # Qualità Media (Disegna il 50% delle fette)
			else:
				render_step = 1 # Qualità Alta (100%)
	
	update_layers_transform(render_step)
	
	#for sprite in layers:
		#sprite.global_rotation = sprite_rotation
	#
	#for i in range(layers.size()):
		## Ogni fetta si sposta leggermente verso l'esterno dello schermo
		#layers[i].position = Vector2(0, -(vertical_spacing / 3.0) * i) + (offset_dir * distance * i * 0.1)
	
	#if Input.is_action_pressed("ggt_debug_step_frame"):
		#sprite_rotation += 0.1
	#
	#print(sprite_rotation)


func update_layers_transform(step: int) -> void:
	var screen_center = get_viewport_rect().size / 2.0
	var pos_on_screen = get_global_transform_with_canvas().origin
	var offset_dir = (pos_on_screen - screen_center).normalized()
	var distance_from_center = pos_on_screen.distance_to(screen_center) * 0.02
	
	for i in range(layers.size()):
		var sprite = layers[i]
		
		if i % step != 0:
			if sprite.visible:
				sprite.visible = false
			continue
		
		if not sprite.visible:
			sprite.visible = true
		
		sprite.global_rotation = sprite_rotation
		
		sprite.position = Vector2(0, -(vertical_spacing / 3.0) * i) + (offset_dir * distance_from_center * i * 0.1)


func stack_sprites() -> void:
	if get_child_count() > 0:
		for child in get_children():
			child.queue_free()
		layers.clear()
	
	if texture == null:
		if not Engine.is_editor_hint():
			push_warning("NO TEXTURE ASSIGNED!!")
		return
	
	for i in range(sprite_hframes):
		var stacked_sprites: Sprite2D = Sprite2D.new()
		stacked_sprites.texture = texture
		
		stacked_sprites.hframes = sprite_hframes
		stacked_sprites.frame = i
		
		stacked_sprites.position = Vector2(0, -vertical_spacing * i)
		stacked_sprites.process_mode = Node.PROCESS_MODE_INHERIT
		
		add_child.call_deferred(stacked_sprites)
		layers.append(stacked_sprites)

func _physics_process(delta: float) -> void:
	if get_child_count() > 0:
		for i in get_children():
			if spin_sprite:
				spin_rotation_value += delta * spin_speed
