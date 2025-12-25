@tool
extends Node2D
class_name stackedsprite

@export var texture: Texture2D
@export var sprite_hframes := 10
@export var vertical_spacing := 1.0

@export var sprite_rotation := 0.0
@export var spin_sprite := false
@export var spin_speed := 1.0
var spin_rotation_value := 0.0



@warning_ignore("unused_private_class_variable")
@export_tool_button("Stack Sprite!") var _restack_button: Callable = func():
	stack_sprites()

var layers: Array[Sprite2D] = []

#TODO RISOLVERE Z-INDEX TRA STACK-SPRITES

func _ready() -> void:
	stack_sprites()
	for sprite in layers:
		sprite.global_rotation = sprite_rotation


func _process(_delta: float) -> void:
	for sprite in layers:
		sprite.global_rotation = sprite_rotation
	
	#if Input.is_action_pressed("ggt_debug_step_frame"):
		#sprite_rotation += 0.1
	#
	#print(sprite_rotation)


func stack_sprites() -> void:
	if get_child_count() > 0:
		for child in get_children():
			child.queue_free()
		layers.clear()
	
	if texture == null:
		push_warning("NO TEXTURE ASSIGNED!!")
		return
	
	for i in range(sprite_hframes):
		var stacked_sprites: Sprite2D = Sprite2D.new()
		stacked_sprites.texture = texture
		
		stacked_sprites.hframes = sprite_hframes
		stacked_sprites.frame = i
		
		stacked_sprites.position = Vector2(0, -vertical_spacing * i)
		add_child.call_deferred(stacked_sprites)
		layers.append(stacked_sprites)

func _physics_process(delta: float) -> void:
	if get_child_count() > 0:
		for i in get_children():
			if spin_sprite:
				spin_rotation_value += delta * spin_speed
