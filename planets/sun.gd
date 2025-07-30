extends Attachable
@export var rotation_speed: float = 1 / 10.
@export var distance: Vector2
@export var time: float

func _process(delta: float) -> void:
	time += delta * rotation_speed
	global_position = (distance - attached.global_position).rotated(time) + attached.global_position
