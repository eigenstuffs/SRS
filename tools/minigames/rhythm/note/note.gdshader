shader_type spatial;

varying vec3 world_pos;

instance uniform vec4 albedo : source_color = vec4(1.0, 0.33, 0.0, 1.0);
instance uniform vec3 target_position = vec3(0.0);
instance uniform vec3 velocity = vec3(0.,0.,-1.);
instance uniform vec3 mesh_scale = vec3(1.0);

instance uniform bool should_hide_at_target_position = false;
uniform float transition_distance_start = 4.95;
uniform float transition_distance = 1.0;

uniform sampler2D tex;

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	// Identical to note.gdshader
	float t = distance(target_position, world_pos) - (transition_distance_start - transition_distance);
	t /= transition_distance;
	t = clamp(t, 0., 1.);
	ALPHA = smoothstep(1.0, 0.0, t);

	// Treat velocity as a plane normal and check if the position of the vertex
	// is on the front face of the plane translated by the target position.
	if (should_hide_at_target_position)
		ALPHA = step(0., dot(velocity, world_pos - target_position));

	// Tile texture according to provided scaling
	//ALBEDO = texture(tex, vec2(UV.x / mesh_scale.z, UV.y)).rgb;
	ALBEDO = albedo.rgb;
}

void light() {
	 // Called for every pixel for every light affecting the material.
	 // Uncomment to replace the default light processing function with this one.
}
