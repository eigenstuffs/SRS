shader_type spatial;

uniform sampler2D noise_texture;
uniform float displacement_factor = 0.5;
uniform float displacement_scale = 0.1;
uniform float animation_speed = 0.1;

varying float height;

void vertex() {
	height = texture(noise_texture, VERTEX.xz * displacement_scale + TIME * animation_speed).r - 0.5;
	VERTEX += NORMAL * height * displacement_factor;
}

void fragment() {
	vec3 view_world = (INV_VIEW_MATRIX * vec4(VIEW, 0.0)).xyz;
	vec3 normal_world = (INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;
	float fresnel = 1.0 - abs(dot(view_world, normal_world));

	ROUGHNESS = mix(0.05, 0.1, 1.0 - height);
	ALPHA = mix(0.0, 0.5, fresnel);
	ALBEDO = vec3(0.6,0.8,1.0);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
