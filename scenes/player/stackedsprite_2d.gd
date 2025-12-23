@tool
extends Sprite2D

@export var show_sprites := false: set = set_show_sprites
@export var rotate_sprites := false: set = set_rotate_sprites

func _ready() -> void:
	render_sprites()


func set_rotate_sprites(_rotate_sprites) -> void:
	rotate_sprites = _rotate_sprites

func rotate_sprite(_rotation) -> void:
	for sprite in get_children():
		sprite.rotation = _rotation


func set_show_sprites(_show_spites) -> void:
	show_sprites = _show_spites
	if show_sprites:
		render_sprites()
	else:
		pass


func clear_sprites() -> void:
	for sprite in get_children():
		sprite.queue_free()

func render_sprites() -> void:
	clear_sprites()
	for i in range(0, hframes):
		var next_sprite := Sprite2D.new()
		next_sprite.texture = texture
		next_sprite.hframes = hframes
		next_sprite.frame = i
		next_sprite.position.y = -i
		add_child(next_sprite)
