shader_type canvas_item;
render_mode unshaded;

global uniform float cpu_sync_time;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

uniform float t0;
uniform float t1;
uniform float duration;
uniform float start_time;

vec2 hash(in uvec2 x) {
    x = 1103515245U * ((x >> 1U) ^ (x.yx));
    uint h32 = 1103515245U * ((x.x) ^ (x.y >> 3U));
    uint n = h32 ^ (h32 >> 16U);
    uvec2 rz = uvec2(n, n*48271U);
    return vec2((rz.xy >> 1U) & uvec2(0x7FFFFFFFU)) / float(0x7FFFFFFF);
}

void fragment() {
	float t = mix(t0, t1, min(1.0, (cpu_sync_time - start_time) / duration));
	vec3 col0 = texture(screen_texture, SCREEN_UV).rgb;
	vec3 col1 = texture(screen_texture, SCREEN_UV + (hash(uvec2(FRAGCOORD.xy)) - 0.5) * 0.1*t).rgb;
    COLOR.rgb = mix(col0, col1, 0.15*t);
}
