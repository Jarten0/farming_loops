class_name Attachable
extends Node2D

@export var attached: Node2D

 
func _physics_process(delta: float) -> void:
	if !attached:
		return

	const DISTANCE: float = 5000; # export on attaching later
	var new_pos = (global_position - attached.global_position).normalized();
	global_position = (new_pos * DISTANCE) + attached.global_position;
	
	global_rotation = (new_pos * Vector2(-1,1)).angle_to(Vector2.UP)
	
