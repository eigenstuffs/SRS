shader_type spatial;

uniform sampler2D tex : source_color;

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = texture(tex, SCREEN_UV).rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
