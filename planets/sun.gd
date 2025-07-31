extends Node2D

@export var root_node: Collections
@export var rotation_speed: float = 1 / 10.
@export var distance: Vector2
@export var time: float
@export var speed: float
@export var velocity: Vector2
@export var targetted_planet: Planet
var step = 0 # used for simulation tracking

func _physics_process(delta: float) -> void:
	step += 1; 
	for planet in root_node.planets:
		if planet.global_position.distance_squared_to(global_position) < pow(planet.size, 2):
			continue
		if planet.global_position.distance_squared_to(global_position) - pow(planet.size * planet.density_modifier + 1000, 2) < pow(planet.size, 2):
			var distance = (planet.global_position - global_position)
			var grav_force = (-pow(1.1, distance.length() / 1000.) + 1000) 
			if grav_force < 0:
				targetted_planet = planet
				continue
			
			velocity += grav_force * distance.normalized() * delta * planet.density_modifier
	
	const MAX_DISTANCE: float = 35_000
	if global_position.length_squared() > pow(MAX_DISTANCE, 2):
		velocity += -position.normalized() \
			* max(abs(position.x) - MAX_DISTANCE, abs(position.y) - MAX_DISTANCE) \
			/ 1. * delta;
			
	if targetted_planet:
		var target_velocity = (global_position - targetted_planet.global_position) \
			.normalized().rotated(90.) * targetted_planet.size * targetted_planet.density_modifier
		var target_distance = targetted_planet.size * 2;
		velocity += (target_velocity - velocity) * 0.8 * delta;
		var distance_from_target = position.distance_to(target_distance)
		velocity += distance_from_target * delta
		
	
	position += velocity * delta
