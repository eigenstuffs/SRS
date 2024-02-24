shader_type spatial;
render_mode unshaded;
/** An empty 'pass-through shader' analogous to blit*/

void fragment() {
	// Called for every pixel the material is visible on.
	ALPHA = 0.0;
}
