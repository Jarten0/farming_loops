extends ColorRect

@export var collections: Collections
@export var camera: Camera2D
@export var sun: Node2D

func _process(delta: float) -> void:
	var near_planet: Planet
	for planet in collections.planets:
		var distance = camera.global_position - planet.global_position
		if distance.length() < planet.size * 20.:
			near_planet = planet
			break
			
	if !near_planet:
		(material as ShaderMaterial).set_shader_parameter("near_planet_pos", Vector2.ZERO)
		(material as ShaderMaterial).set_shader_parameter("near_planet_size", Vector2.ZERO)

		return
		
	var new_transform = get_viewport().canvas_transform * near_planet.global_transform
	var camera_scale = camera.zoom.x
	var sun_transform = get_viewport().canvas_transform * sun.global_transform
	
	(material as ShaderMaterial).set_shader_parameter("near_planet_pos", new_transform.get_origin())
	(material as ShaderMaterial).set_shader_parameter("near_planet_size", near_planet.size * camera_scale)
	(material as ShaderMaterial).set_shader_parameter("sun_pos", sun_transform.get_origin() )
	
