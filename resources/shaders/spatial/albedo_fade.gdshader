shader_type spatial;
render_mode unshaded;

global uniform float cpu_sync_time;
uniform vec4 albedo : source_color = vec4(0.0, 0.0, 0.0, 0.0);
uniform float start_time;

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = albedo.rgb;
	ALPHA = min((cpu_sync_time - start_time) / 12.0, 1.0) * albedo.a;
}
