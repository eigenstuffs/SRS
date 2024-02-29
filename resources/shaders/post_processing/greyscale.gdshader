shader_type spatial;
render_mode unshaded;

uniform sampler2D screen_texture : source_color, hint_screen_texture;

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	vec3 screen_color = texture(screen_texture, SCREEN_UV).xyz;
	float grey = screen_color.r*0.299 + screen_color.g*0.587 + screen_color.b*0.114;
	ALBEDO = vec3(grey);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
