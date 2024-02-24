shader_type spatial;
render_mode unshaded;
/**
 * Screen space shader that emulates "impact lines" for effects such as speed or
 * intensity. Also it's ripped straight from a mod I made lmao.
 */

const float SUBDIVISIONS = 128.0;
uniform float max_alpha = 0.7;
const float RELATIVE_SPEED = 7.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float weight = 0.5;     // Intensity
uniform float bias_angle = 0.0; // Intensity
uniform float bias_weight = 0.0;

// Source: https://www.shadertoy.com/view/Xt3cDn
float hash(in uint x) {
    x = 1103515245U * ((x >> 1U) ^ (x));
    uint h32 = 1103515245U * ((x) ^ (x >> 3U));
    return float(h32 ^ (h32 >> 16U)) * (1.0 / float(0xFFFFFFFFU));
}

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

// signed distance to a n-star polygon with external angle en
// Source: https://iquilezles.org/articles/distfunctions2d/
// p : position, r : radius, n : num sides, m : angle divisor
float lines_sdf(in vec2 p, in float r, in uint n, in float m) { // m=[2,n]
    // these 4 lines can be precomputed for a given shape
    float an = PI / float(n);
    float en = PI / m;
    vec2 acs = vec2(cos(an), sin(an));
    vec2 ecs = vec2(cos(en), sin(en)); // ecs=vec2(0,1) and simplify, for regular polygon,

    // reduce to first sector
    float bn = mod(atan(p.x, p.y), 2.f * an) - an;
    p = length(p) * vec2(cos(bn), abs(sin(bn)));

    // line sdf
    p -= r * acs;
    p += ecs * clamp(-dot(p, ecs), 0.f, r * acs.y / ecs.y);
    return length(p) * sign(p.x);
}

mat2 rotate(in float a) {
	return mat2(vec2(cos(a), sin(a)), vec2(-sin(a), cos(a)));
}

void fragment() {
    vec3 tex = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
    vec2 st = SCREEN_UV - 0.5;

    // These can be calculated on the CPU
    float weight_normalized = mix(0.8f, 1.f, weight);
    st += -0.08f*bias_weight * vec2(cos(bias_angle), sin(bias_angle));

    // Normalized angle ∈ [0, 1]
    float angle = atan(st.t, st.s);
    float angle_normalized = (0.5f * angle) / PI;

    // These should be calculated on the CPU
    float angle_bias = bias_weight*cos(angle - bias_angle) + (1.f - bias_weight);
    // We generate a seed for each line based on its angle.
    float s_rand = mix(0.5f, 1.f, hash(floatBitsToUint(floor(angle_normalized * SUBDIVISIONS))));

    // We also denote some parameters for the animation progress
    float s_time = RELATIVE_SPEED * s_rand * TIME;
    float shape = fract(s_time);     // Animation progress
    float iteration = floor(s_time); // Animation Iteration

    // We want an iteration-specific hash so that spike radius isn't dependent
    // purely on angle.
    float p_rand = mix(0.5f, 1.f, hash(uint(iteration)));
    float luminance = dot(tex, vec3(0.2126, 0.7152, 0.0722));
    float target_alpha = max_alpha * mix(0.15f, 1.f, luminance);
    float line_radius = 1.f - pow(max(0.f, 1.6f * shape - 0.6f), 2.f);
    float line_alpha =  2.f*shape * target_alpha*weight;

    st *= 0.6f;                    // Scale out space for 'sharper' lines.
    st *= rotate(s_rand + p_rand); // Rotate by a random amount

    float w = 162.f*line_radius * SUBDIVISIONS / 90.f;
    w *= 0.4f * p_rand;                  // Add random factor to spikiness.
    w *= angle_bias * weight_normalized; // Incorporate angular bias
    w = max(2.f, w);                     // w ∈ [2,SUBDIVISIONS]

    float d = lines_sdf(st, 0.7f, uint(SUBDIVISIONS), w);
    float col = (d > 0.f) ? 1.0 : 0.0;
    // Use smoothstep() for anti-aliasing
    col = mix(col, 1.f, 1.f - smoothstep(0.f, 0.001f, abs(d)));
    // Alpha increases when line begins to recede
	ALPHA = mix(0.0, col, line_alpha);
}