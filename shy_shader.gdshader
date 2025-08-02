shader_type canvas_item;

uniform vec2 near_planet_pos;
uniform float near_planet_size;
uniform vec2 sun_pos;
uniform float test;

void fragment() {
	float distance_from_planet = length(FRAGCOORD.xy - near_planet_pos);
	vec2 direction = normalize(FRAGCOORD.xy - near_planet_pos);
	vec2 direction2 = normalize(sun_pos - near_planet_pos);
	float sun_distance = length(sun_pos - near_planet_pos) ;
	float dot_result = ((dot(direction, direction2) * sun_distance) );
	
	float distance_ = distance(FRAGCOORD.xy, near_planet_pos) / near_planet_size;
	
	float correct_direction = clamp(dot_result - 1.5, 0., 1.);
	float clamped_color = clamp(distance_ - 0.6, 0.0, 1.0);
	float blue = clamp((distance_ / 1.3) -0.6, 0.0, 1.0);
		
	vec4 gradient = vec4((0.8 * correct_direction) - (clamped_color / 1.2) );
	vec4 blue_gradient = vec4(0., 0., (1. * correct_direction) - blue, 1.);
	gradient.a = 1.;
	
	COLOR = (blue_gradient + gradient) ;
	//COLOR = vec4(direction.x, direction.y, dot_result, 1.);
	//COLOR = vec4((correct_direction));
	//if (distance(FRAGCOORD.xy, near_planet_pos) < 30.) {
		//COLOR = vec4(0.,0.,0.,1.);
	//}
}
