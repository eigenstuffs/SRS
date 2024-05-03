shader_type spatial;
render_mode unshaded;

uniform sampler2D noise_texture : repeat_enable;

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = SCREEN_UV * vec2(VIEWPORT_SIZE.x / VIEWPORT_SIZE.y, 1);
	uv.x /= 30.0;
	uv.x += floor(TIME * 24.0) * 0.03;
	
	vec3 col = texture(noise_texture, uv).rgb;
	col = mix(col, vec3(0.0), 0.1);
	col = mix(col, vec3(1.0), 0.2);
	
	ALBEDO = col;
}
