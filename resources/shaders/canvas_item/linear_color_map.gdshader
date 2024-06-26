shader_type canvas_item;
render_mode unshaded;

global uniform float cpu_sync_time;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform mat3 transformation_matrix;
uniform float t0;
uniform float t1;
uniform float duration;
uniform float start_time;

// Source: https://www.shadertoy.com/view/ttcyRS
vec3 oklab_mix(vec3 colA, vec3 colB, float h) {
    // https://bottosson.github.io/posts/oklab
    const mat3 kCONEtoLMS = mat3(                
		vec3( 0.4121656120,  0.2118591070,  0.0883097947),
		vec3( 0.5362752080,  0.6807189584,  0.2818474174),
		vec3( 0.0514575653,  0.1074065790,  0.6302613616));
    const mat3 kLMStoCONE = mat3(
        vec3( 4.0767245293, -1.2681437731, -0.0041119885),
        vec3(-3.3072168827,  2.6093323231, -0.7034763098),
        vec3( 0.2307590544, -0.3411344290,  1.7068625689));
                    
    // rgb to cone (arg of pow can't be negative)
    vec3 lmsA = pow( kCONEtoLMS*colA, vec3(1.0/3.0) );
    vec3 lmsB = pow( kCONEtoLMS*colB, vec3(1.0/3.0) );
    // lerp
    vec3 lms = mix( lmsA, lmsB, h );
    // gain in the middle (no oaklab anymore, but looks better?)
  //lms *= 1.0+0.2*h*(1.0-h);
    // cone to rgb
    return kLMStoCONE*(lms*lms*lms);
}

void fragment() {
	vec3 frag_color = texture(screen_texture, SCREEN_UV).rgb;
	vec3 mapped_color = frag_color * transformation_matrix;
	vec3 c1 = oklab_mix(frag_color, mapped_color, t1);
	
	float t = min(1.0, (cpu_sync_time - start_time) / duration);
	if (t >= 1.0) {
		COLOR.rgb = c1;
	} else {
		// Just use normal mix() if performance becomes an issue
		vec3 c0 = oklab_mix(frag_color, mapped_color, t0);
		COLOR.rgb = oklab_mix(c0, c1, t);
	}
}