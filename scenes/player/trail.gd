extends Line2D

var fading := false


func _ready() -> void:
	set_as_top_level(true)
	z_index = -1


func stop_drawing() -> void:
	fading = true
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 5.0)
	tween.tween_callback(queue_free)


func add_track_point(pos: Vector2) -> void:
	if not fading:
		add_point(pos)
		
		if get_point_count() > 200:
			remove_point(0)


#func _physics_process(_delta: float) -> void:
	#point = get_parent().global_position
	#add_point(point)
	#
	#if point.size() > 100:
		#remove_point(0)
