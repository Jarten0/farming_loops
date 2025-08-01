extends Camera2D

@export var target: Node2D
@export_enum( "None", "Player", "Distant", "Space",) var mode
@export var target_zoom: Vector2
@export var target_rotation: float

func _process(delta: float) -> void:
	var target_pos = (target.global_position - global_position)
	global_position += target_pos * clamp(delta * 10., 0, 1);
	zoom += (target_zoom - zoom) * clamp(delta * 10., 0, 1);
	
	var d1 = (target_rotation - rotation)
	var d2 = (target_rotation + rotation - 180)
	if abs(d1) <= abs(d2):
		rotation += d1 * clamp(delta * 10., 0, 1);
	else:
		rotation += d2 * clamp(delta * 10., 0, 1);
	
	
	if Input.is_action_just_pressed("toggle_camera"):
		toggle_camera()
	
	match mode:
		"Player":
			target_zoom = Vector2(0.6, 0.6)
		"Range":
			target_zoom = Vector2(0.2, 0.2)
		"Space":
			target_zoom = Vector2(0.02, 0.02)
	
func toggle_camera(set: String = ""):
	if set != "":
		mode = set
		return
		
	match mode:
		"Player":
			mode = "Range"
		"Range":
			mode = "Space"
		"Space":
			mode = "Player"
		_:
			mode = "Player"
