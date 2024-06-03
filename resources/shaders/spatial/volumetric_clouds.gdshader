shader_type spatial;
render_mode unshaded;
/**
 * --- Raymarched volumentric clouds ---
 * General structure heavily inspired by: https://www.shadertoy.com/view/XslGRr
 */

#define FOV       (70.)
#define MAX_STEPS (50)

uniform sampler3D noise_texture;
uniform sampler2D blue_noise_texture;

float noise(in vec3 x) {
    vec3 p = floor(x);
    vec3 f = smoothstep(0.0, 1.0, fract(x));
    return texture(noise_texture, (p+f + 0.5) / 32.0).x*2.0 - 1.0;
}

#define NUM_OCTAVES 4
float fbm(in vec3 pos) {
	vec3 s = pos - vec3(0.2, 0.1, 1.0)*TIME;
	
	float value = 0.0, amplitude = 0.4;
	for (int i = 0; i < NUM_OCTAVES; i++) {
	    value += amplitude * noise(s);
	    s *= 2.66666;
	    amplitude *= 0.5;
	} 
	return 1.5*value - pos.y;
}

void fragment() {
	// --- Basis ---
	float aspect_ratio = VIEWPORT_SIZE.x / VIEWPORT_SIZE.y;
	vec2 uv = (SCREEN_UV - 0.5) * vec2(aspect_ratio, 1); uv.y *= -1.0;
	float w = -1.0 / tan(radians(FOV)*0.5);
	
	// --- World ---
	const vec3 camera_origin = vec3(0, 0.5, 1.5);
	const vec3 light_pos = vec3(0.0, 0.0, -1.0);
	const vec3 light_dir = normalize(light_pos - camera_origin);
	
	vec3 ro = camera_origin;
	vec3 rd = normalize(vec3(uv, w));
    float light = clamp(dot(light_dir, rd), 0.0, 1.0);
	
	// --- Color ---
	const vec3 base = vec3(0.6, 0.6, 0.75)*1.1;
	const vec3 refracted = vec3(1.0, 0.6, 0.3)*0.8;
    // Sky color calculations
	vec4 sum = vec4(0.0);
    vec3 col = vec3(0.55, 0.6, 0.8);
    col -= vec3(0.9, 0.7, 0.9)*0.8 * rd.y;
	col += vec3(1.0, 0.3, 0.1)*0.5 * pow(light, 15.0);
		
	// Reduce banding artifacts with offset from sampled blue noise
    float t = mix(1.2, 1.3, texelFetch(blue_noise_texture, ivec2(FRAGCOORD.xy-0.5) & ivec2(255), 0).x);
	for (int s = 0; s < MAX_STEPS && sum.a < 0.99; ++s) {
		float density = fbm(ro + t*rd);
		if (density > 1e-3) {
			// Diffuse lighitng from directional derivatives
			float diffuse = clamp((density - fbm(ro + t*rd + 0.3*light_dir)) / 0.3, 0.0, 1.0);
			vec3 cloud_color = vec3(mix(0.6, 0.0, density));
			cloud_color *= base + refracted*diffuse;
			// Fog contribution
			cloud_color = mix(cloud_color, col, 1.0 - exp(-0.07*t));
			sum += vec4(cloud_color, 1)*density * (1.0 - sum.a);
		}
		t += max(0.12, 0.60*density)*0.4;
	}
	sum = clamp(sum, 0.0, 1.0);
	col = col*(1.0 - sum.a) + sum.rgb;
	
    // Bloom lighting 
	col += vec3(1.0,0.4,0.4)*0.1 * pow(light, 3.0);
	ALBEDO = pow(col, vec3(2.2));
}
