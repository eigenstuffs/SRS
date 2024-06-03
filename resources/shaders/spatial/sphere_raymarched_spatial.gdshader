shader_type spatial;
render_mode unshaded;

#define AA_PASSES (1)
#define FOV       (70.)
#define MAX_STEPS (50)
#define TILE_SIZE (3.)

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// --- SDF Operators ---
// Source: https://iquilezles.org/articles/smin/
float union(float a, float b, float k) {
    float h = clamp(0.5+0.5*(b-a)/k, 0.0, 1.0);
    return mix(b, a, h) - k*h*(1.0-h);
}

float sphere_sdf(in vec3 p, in float radius) {
	return length(p) - radius;
}

// Source: https://iquilezles.org/articles/distfunctions/
float torus_sdf(vec3 p, vec2 t) {
	vec2 q = vec2(length(p.xz) - t.x, p.y);
	return length(q) - t.y;
}

// Source: https://www.shadertoy.com/view/Xt3cDn
float hash(in uvec2 x) {
    x = 1103515245U * ((x >> 1U) ^ (x.yx));
    uint h32 = 1103515245U * ((x.x) ^ (x.y >> 3U));
    return float(h32 ^ (h32 >> 16U)) * (1.0 / float(0xFFFFFFFFU));
}

// Source: https://iquilezles.org/articles/sdfrepetition/
float scene_sdf(in vec3 p) {
    vec3 id = round(p / TILE_SIZE);
    vec3 offset = sign(p - TILE_SIZE*id); // neighbor offset direction
    
    float d = 1e20;
	for (int i = 0; i < 2; i++)
    for (int j = 0; j < 2; j++)
	for (int k = 0; k < 2; k++) {
        vec3 rid = id + vec3(float(i),float(j),float(k))*offset;
		float h = mix(0.25, 0.75, hash(uvec2(rid.xz + 314.15)));
        vec3 r = p - TILE_SIZE*rid;
        d = min(d, union(
			sphere_sdf(r + vec3(h, mod(TIME*0.5*h, TILE_SIZE) - TILE_SIZE*0.5, h), cos(TIME*h)*0.1 + 0.5), 
			torus_sdf(r + vec3(h, -(mod(TIME*0.3*h, TILE_SIZE) - TILE_SIZE*0.5), h), vec2(0.6, 0.15)), 
			0.3));
    }
	return d;
}

// Source: https://iquilezles.org/articles/normalsSDF/
vec3 scene_normal(in vec3 p) {
    const float h = 0.0005; // replace by an appropriate value
    const vec2 k = vec2(1,-1);
    return normalize(k.xyy*scene_sdf(p + k.xyy*h) + 
                     k.yyx*scene_sdf(p + k.yyx*h) + 
                     k.yxy*scene_sdf(p + k.yxy*h) + 
                     k.xxx*scene_sdf(p + k.xxx*h));
}

vec3 sample_texture(in sampler2D tex, in vec3 n) {
	// Source: https://gamedev.stackexchange.com/a/201460
	vec2 uv = vec2(atan(n.x, n.z)*0.5, asin(-n.y))/PI + 0.5;
	return texture(tex, uv).rgb;
}

void fragment() {
	// --- Basis ---
	float aspect_ratio = VIEWPORT_SIZE.x / VIEWPORT_SIZE.y;
	vec2 uv = (SCREEN_UV - 0.5) * vec2(aspect_ratio, 1); uv.y *= -1.0;
	float w = -1.0 / tan(radians(FOV)*0.5);
	
	// --- World ---
	const vec3 camera_origin = vec3(0, 0, 1.5);
	const vec3 light_pos0 = normalize(vec3(1));
	const vec3 light_pos1 = normalize(vec3(0,0,-1));
	
	// --- Color ---
	const vec3 orange = vec3(0.3, 0.0, 0.05);
	const vec3 white = vec3(0.4);
	const vec3 rim_col = (orange + white)*6.0;
	float glow0 = pow(1.0 - length(SCREEN_UV-0.5), 3.0);
	float glow1 = pow(glow0, 3.0);
	
	ALBEDO = vec3(0);
    for (int i = 0; i < AA_PASSES; i++)
    for (int j = 0; j < AA_PASSES; j++) {
		vec3 col = vec3(0.0);
		col = mix(col, orange, glow0);
		col = mix(col, white, glow1);
        vec2 offset = (vec2(float(i)*aspect_ratio, float(j)) / float(AA_PASSES) - 0.5)/VIEWPORT_SIZE;
		
		vec3 ro = camera_origin;
		vec3 rd = normalize(vec3(uv + offset, w));
		
		float t = 0.0;
		for (int s = 0; s < MAX_STEPS; s++) {
			float dist = scene_sdf(ro + t*rd);
			if (dist < t*0.002 || t > 40.0) break;
			t += dist;
		}
		
		if (t < 40.0) {
			vec3 hit_pos = ro + t*rd;
			vec3 hit_normal = scene_normal(hit_pos);
			
			float diffusion = clamp(dot(hit_normal, light_pos0), 0.0, 1.0);
			float occlusion = 0.35*mix(0.0, -hit_normal.y, 0.5);
			float rim = clamp(dot(hit_normal, light_pos1), 0.0, 1.0);
			float fog = exp(-0.13*t);
			col = vec3(0.01) * (diffusion + occlusion + rim*rim_col)*fog;
			col = mix(col, orange, glow0*(1.0 - fog));
			col = mix(col, white, glow1*(1.0 - fog));
		}
		ALBEDO += col;
	}
	ALBEDO /= float(AA_PASSES*AA_PASSES);
}
