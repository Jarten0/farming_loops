extends Area2D

@export var root_node: Collections
@export var rotation_speed: float = 1 / 10.
@export var distance: Vector2
@export var time: float
@export var speed: float
@export var velocity: Vector2

func _physics_process(delta: float) -> void:
	for planet in root_node.planets:
		if planet.global_position.distance_squared_to(global_position) < pow(planet.size, 2):
			continue
		if planet.global_position.distance_squared_to(global_position) - pow(planet.size * planet.density_modifier + 1000, 2) < pow(planet.size, 2):
			var distance = (planet.global_position - global_position)
			var grav_force = (-pow(1.1, distance.length() / 1000.) + 1000) 
			if grav_force < 0:
				continue
			
			velocity += grav_force * distance.normalized() * delta * planet.density_modifier
	position += velocity * delta
