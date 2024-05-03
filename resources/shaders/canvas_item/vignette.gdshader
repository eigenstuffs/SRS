shader_type canvas_item;
render_mode unshaded;

// Source: https://www.shadertoy.com/view/lsKSWR
void fragment() {
	vec2 uv = SCREEN_UV;
    uv *= 1.0 - SCREEN_UV.yx;
    COLOR = vec4(0, 0, 0, 1.0 - pow(uv.x*uv.y * 15.0, 0.25)); 
}
