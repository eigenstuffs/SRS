shader_type canvas_item;
render_mode unshaded;

#define AA_PASSES (2)
#define FOV (90.)

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// https://iquilezles.org/articles/intersectors/
float ray_sphere_intersection(in vec3 ro, in vec3 rd, in vec4 sphere) {
	vec3 oc = ro - sphere.xyz;
	float b = dot(oc, rd);
	float c = dot(oc, oc) - sphere.w*sphere.w;
	float det = b*b - c;
	return (det < 0.0) ? -1.0 : -b - sign(det) * sqrt(det);
}

vec3 sphere_normal(in vec3 pos, in vec3 center) {
	return normalize(pos - center);
}

vec3 sample_texture(in sampler2D tex, in vec3 n) {
	// Source: https://gamedev.stackexchange.com/a/201460
	vec2 uv = vec2(atan(n.x, n.z)*0.5, asin(-n.y))/PI + 0.5;
	return texture(tex, uv).rgb;
}

void fragment() {	
	// --- Basis ---
	float aspect_ratio = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
	vec2 uv = (SCREEN_UV - 0.5) * vec2(aspect_ratio, 1); uv.y *= -1.0;
	float w = -1.0 / tan(radians(FOV)*0.5);
	
	// --- World ---
	vec3 camera_origin = vec3(0, 0, 2.0);
	vec3 light_pos = normalize(vec3(1));
	vec4 sphere = vec4(vec3(0, sin(TIME)*0.05, 0), 1.0); // w = radius
	
	// --- Color ---
	COLOR.rgb = vec3(0);
    for (int i = 0; i < AA_PASSES; i++) {
    for (int j = 0; j < AA_PASSES; j++) {
		vec3 col = vec3(0);
        vec2 offset = (vec2(float(i)*aspect_ratio, float(j)) / float(AA_PASSES) - 0.5)*SCREEN_PIXEL_SIZE;
		
		vec3 ro = camera_origin;
		vec3 rd = normalize(vec3(uv + offset, w));
		
		float t = ray_sphere_intersection(ro, rd, sphere);
		if (t > 0.0 && t < 1000.0) { // Has hit sphere
			vec3 hit_pos = ro + t*rd;
			vec3 hit_normal = sphere_normal(hit_pos, sphere.xyz);
			
			float diffusion = clamp(dot(hit_normal, light_pos), 0.0, 1.0);
			float occlusion = 0.35*mix(0.0, -hit_normal.y, 0.5);
			float fog = exp(-0.07*t);
			col = sample_texture(screen_texture, hit_normal) * (diffusion + occlusion) * fog;
		}
		COLOR.rgb += col;
	}}
	COLOR.rgb /= float(AA_PASSES)*float(AA_PASSES);
}
