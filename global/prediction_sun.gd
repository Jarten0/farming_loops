extends "res://planets/sun.gd"

@export var base_sun: Node2D
@export var trail_texture: Texture
@export var max_steps: int = 1000
@export var simuli: Array[Sprite2D] = []

func reset_prediction() -> void:
	root_node = base_sun.root_node
	rotation_speed = base_sun.rotation_speed
	distance = base_sun.distance
	time = base_sun.time
	speed = base_sun.speed
	velocity = base_sun.velocity
	targetted_planet = base_sun.targetted_planet
	step = 0
	for child in get_children():
		child.queue_free()

func _ready() -> void:
	reset_prediction()
	for i in range(max_steps):
		simuli.insert(i, null)

func _physics_process(delta: float) -> void:
	
	if base_sun.step % 10 == 0 && simuli[base_sun.step / 10 % 1000]:
		simuli[base_sun.step / 10 % 1000].queue_free()
	
	if step >= max_steps + base_sun.step - 9:
		return
	
	for i in range(10):
		super._physics_process(delta)
	
	var new_sprite: Sprite2D = Sprite2D.new()
	new_sprite.texture = trail_texture
	new_sprite.global_position = global_position
	new_sprite.top_level = true
	new_sprite.scale = Vector2.ONE * 20;
	new_sprite.z_index = (-step % 20) - 20
	$".".add_child(new_sprite)
	var index = (step / 10) % max_steps;
	if simuli[index]:
		simuli[index].queue_free()
	
	simuli[index] = new_sprite
