shader_type spatial;
render_mode unshaded;
/**
 * An fast single-pass blur that uses noise for better approximation.
 */

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform int directions = 3; // More is better but slower
uniform int quality = 2;    // More is better but slower
uniform float start_size = 0.0;
uniform float end_size = 64.0;
uniform float noise_factor = 0.03;

global uniform float cpu_sync_time;
uniform float duration;
uniform float start_time;

varying float inv_directions;
varying float inv_quality;

// Source: https://www.shadertoy.com/view/Xt3cDn
vec2 hash(in uvec2 x) {
    x = 1103515245U * ((x >> 1U) ^ (x.yx));
    uint h32 = 1103515245U * ((x.x) ^ (x.y >> 3U));
    uint n = h32 ^ (h32 >> 16U);
    uvec2 rz = uvec2(n, n*48271U);
    return vec2((rz.xy >> 1U) & uvec2(0x7FFFFFFFU)) / float(0x7FFFFFFF);
}

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
	
    inv_directions = 1.0 / float(directions);
    inv_quality = 1.0 / float(quality);
}

// Source: https://www.shadertoy.com/view/Xltfzj
void fragment() {
	float t = min(1.0, (cpu_sync_time - start_time) / duration);
	t = t*t*t - 3.0*t*t + 3.0*t; // Cubic ease-out
	vec2 radius = mix(start_size, end_size, t) / VIEWPORT_SIZE;
	
	// Noise allows us to approximate a blur with fewer passes. Also gives a 
	// nice-looking frosted glass effect.
	vec2 uv = SCREEN_UV + (hash(uvec2(FRAGCOORD.xy)) - 0.5) * noise_factor * t;
	vec3 col = texture(screen_texture, uv).rgb;
    for (int d = 0; d < directions; d++)
	for (int i = 1; i <= quality; i++) {
		float a = float(d)*inv_directions*TAU;
		col += texture(screen_texture, uv + vec2(cos(a), sin(a)) * float(i)*radius*inv_quality).rgb;
    }
	ALBEDO = col * inv_directions * inv_quality;
}