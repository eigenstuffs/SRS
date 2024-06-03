shader_type spatial;

uniform sampler2D noise_texture;
uniform sampler2D beatmap_texture : source_color;
uniform float displacement_factor = 0.5;
uniform float displacement_scale = 0.1;
uniform float animation_speed = 0.1;

varying vec3 vertex_world;
varying float dist;

mat2 rotate(float theta) {
	float s = sin(theta);
	float c = cos(theta);
	return mat2(vec2(c, s), vec2(-s, c));
}

void vertex() {
	vec3 view = normalize(NODE_POSITION_WORLD - CAMERA_POSITION_WORLD);
	float cos_theta = dot(view, normalize(CAMERA_DIRECTION_WORLD));
	
	VERTEX.xz = rotate(acos(cos_theta)) * VERTEX.xz;
	
	float height = texture(noise_texture, VERTEX.xz * displacement_scale + TIME * animation_speed).r - 0.5;
	VERTEX += NORMAL * height * displacement_factor;
	vertex_world = VERTEX;
	dist = distance(NODE_POSITION_WORLD, CAMERA_POSITION_WORLD);
}

void fragment() {
	ALBEDO = texture(beatmap_texture, vec2(atan(vertex_world.x, vertex_world.z)*0.5 + 0.46, acos(vertex_world.y))).rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
