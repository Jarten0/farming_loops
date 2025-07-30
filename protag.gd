extends "res://attachable.gd"

func _physics_process(delta: float) -> void:
	var input: Vector2 = Vector2.ZERO
	if Input.is_key_pressed(KEY_A):
		input += Vector2.LEFT.rotated(global_rotation)
	if Input.is_key_pressed(KEY_D):
		input += Vector2.RIGHT.rotated(global_rotation)
	global_position += input * delta * 1000.;
	
	super._physics_process(delta)
	pass
