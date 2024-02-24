shader_type spatial;
render_mode unshaded;
/** Tints screen with specified color (albedo)*/

uniform sampler2D screen_texture : source_color, hint_screen_texture;
uniform vec4 albedo : source_color = vec4(0.3, 0.05, 0.1, 0.15);

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	ALBEDO = albedo.rgb;
	ALPHA = albedo.a;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
