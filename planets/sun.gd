extends Attachable
@export var rotation_speed: float = 1 / 10.
@export var distance: Vector2
@export var time: float
@export var velocity: Vector2

func _process(delta: float) -> void:
	var prev = global_position;
	if !attached:
		global_position += velocity;
		return
	time += delta * rotation_speed
	global_position = (distance - attached.global_position).rotated(time) + attached.global_position
	velocity = global_position - prev;
