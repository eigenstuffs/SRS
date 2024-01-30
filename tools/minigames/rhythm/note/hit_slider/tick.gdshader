shader_type spatial;

instance uniform float alpha : instance_index(0) = 0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 color = vec3(1.0, 1.0, 1.0);

	// Called for every pixel the material is visible on.
	ALBEDO = color;
	ALPHA = alpha;
}

void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
}
