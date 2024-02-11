shader_type spatial;
render_mode unshaded;
/**
 * Screen space shader that emulates rain of various strength. Doesn't look super
 * realistic, but is fairly performant for its appearance.
 * 
 * Not my best work but work it does ^^
 */

const float SMOOTHING = 0.1;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec2 tiling_dimensions = vec2(160, 5);
uniform float brightness = 1.0f;

// Source: https://www.shadertoy.com/view/Xt3cDn
float hash(in uvec2 x) {
    x = 1103515245U * ((x >> 1U) ^ (x.yx));
    uint h32 = 1103515245U * ((x.x) ^ (x.y >> 3U));
    return float(h32 ^ (h32 >> 16U)) * (1.0 / float(0xFFFFFFFFU));
}

float circle_sdf(in vec2 st, in float radius) {
    return length(st) - radius;
}

vec2 rotate(in vec2 v, in float a) {
	return mat2(vec2(cos(a), sin(a)), vec2(-sin(a), cos(a))) * v;
}

float rain(in vec2 st, in vec2 dims, in float angle, in float speed, in float probability_harsh, in float soft, in float harsh) {
    st = rotate(st, angle);
    st *= dims; // Vertical tiling
    float speed_factor = (0.3f * hash(uvec2(uint(st.x)) << 2U) + 0.7f);
    
    // Mitigate precision error on time accumulation
    st.y -= mod(speed_factor*TIME, dims.y) * speed;
    st = vec2(st.x, mod(st.y, dims.y));
    
    float t = hash(uvec2(floor(st)));
    float soft_col = mix(0.0, 1.0, soft*t);
    
    float d = circle_sdf(fract(st)-0.5, 0.5-SMOOTHING);
    float harsh_col = mix(0.0, smoothstep(SMOOTHING, 0.0, d), harsh);
    
    return soft_col + (t < probability_harsh ? harsh_col : 0.0);
}

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {	
    vec2 st = FRAGCOORD.xy / VIEWPORT_SIZE.y;
	vec3 tex = texture(SCREEN_TEXTURE, st).rgb;

    float col = rain(st, tiling_dimensions, -PI/8.f, 20.f, 0.05f, 0.015, 0.05);
    // col += rain(st, tiling_dimensions * 1.5, -PI/9.f, 10.f, 0.5f, 0., 0.01);
	ALPHA = col;
}