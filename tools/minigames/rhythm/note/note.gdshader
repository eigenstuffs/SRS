shader_type spatial;

varying vec3 world_pos;

instance uniform vec4 albedo : source_color = vec4(1.0, 0.33, 0.0, 1.0);
instance uniform vec3 target_position = vec3(0.0);
uniform float transition_distance_start = 4.95;
uniform float transition_distance = 1.0;

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	float t = distance(target_position, world_pos) - (transition_distance_start - transition_distance);
	t /= transition_distance;
	t = clamp(t, 0., 1.);
	ALBEDO = albedo.rgb;
	ALPHA = smoothstep(1.0, 0.0, t);
}

void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
}
