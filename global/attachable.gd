class_name Attachable
extends Node2D

@export var attached: Planet

 
func _physics_process(delta: float) -> void:
	if !attached:
		return

	var new_pos = (global_position - attached.global_position).normalized();
	global_position = (new_pos * attached.size) + attached.global_position;
	
	global_rotation = (new_pos * Vector2(-1,1)).angle_to(Vector2.UP)
	
