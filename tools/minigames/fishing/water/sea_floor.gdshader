shader_type spatial;

uniform sampler2D height_map;

float sample(vec2 offset, float scale) {
	return (sin(offset[0])*sin(offset[1]) - 0.5)*scale;
}

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX.y += texture(height_map, VERTEX.xz).x - 0.5;
	VERTEX.y += sample(VERTEX.xz*0.2+vec2(5,9), 2.0);
	VERTEX.y += sample(VERTEX.xz*0.7+vec2(3,-3), 0.5);
	VERTEX.y -= sample(VERTEX.xz*0.3+vec2(-2,1), 0.4);
	VERTEX.y -= sample(VERTEX.xz+vec2(4,-2), 0.8);
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = texture(height_map, UV).xyz;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
