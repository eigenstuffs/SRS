shader_type spatial;
render_mode unshaded;

global uniform float cpu_sync_time;
uniform float start_time;
uniform float factor = 0.3;
uniform float duration = 0.5;

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = vec3(0.8);
	ALPHA = max(0.5 - (cpu_sync_time - start_time) / duration, 0.0) * factor;
}
