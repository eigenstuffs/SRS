shader_type spatial;
render_mode specular_toon;

#define SEPARATE_FOAM_NORMAL
#define USE_FRESNEL
//#define SIMPLE_WAVES

uniform sampler2D depth_texture : source_color, hint_depth_texture;
uniform sampler2D screen_texture : source_color, hint_screen_texture;
uniform sampler2D refract_normal : hint_normal;
uniform sampler2D foam_noise_texture : source_color;
uniform sampler2D height_texture : hint_normal;

//uniform vec4 shallow_color : source_color = vec4(0.12, 0.36, 0.36, 0.95);
uniform vec4 shallow_color : source_color = vec4(0.12, 0.36, 0.75, 0.95);
//uniform vec4 deep_color : source_color = vec4(0.01, 0.16, 0.25, 0.988);
uniform vec4 deep_color : source_color = vec4(0.15, 0.16, 0.8, 0.988);
uniform vec4 foam_color : source_color;

uniform float depth_factor;

uniform vec3 refract_scale; // xy=uv scale, z=time scale
uniform float refract_factor;

uniform vec3 foam_scale;    // xy=uv scale, z=time scale
uniform float foam_factor : hint_range(0, 8);

//uniform float height_frequency : hint_range(0, 1.571); // in [0, PI/2] rad
uniform float wave_speed : hint_range(0, 3);
uniform float wave_amplitude : hint_range(0, 1);

uniform float normal_strength : hint_range(0, 1);
uniform float roughness : hint_range(0, 1);

varying vec2 vertex_offset;
varying float vert_hash;

// Source: https://www.shadertoy.com/view/Xt3cDn
float hash(in uint x) {
    x = 1103515245U * ((x >> 1U) ^ (x));
    uint h32 = 1103515245U * ((x) ^ (x >> 3U));
    return float(h32 ^ (h32 >> 16U)) * (1.0 / float(0xFFFFFFFFU));
}

float wave(in vec2 position){
	position += texture(height_texture, position * 0.1).x * 2.0 - 1.0;
	vec2 wv = 1.0 - abs(sin(position));
	return pow(1.0 - pow(wv.x * wv.y, 0.65), 4.0);
}

float height(in vec2 position, in float time) {
	// We slightly randomize low-frequency sampling to reduce pattern
	time *= wave_speed;
	float d = wave((position + time) * 0.4) * 0.3 * vert_hash;
	d += wave((position - time) * 0.3) * 0.3;
	d += wave((position + time) * 0.5) * 0.2;
	d += wave((position - time) * 0.6) * 0.2;
	return d;
}

void vertex() {
	// Called for every vertex the material is visible on.
#ifdef SIMPLE_WAVES
	const float height_frequency = 1.571;
	float wave = sin(VERTEX.x*height_frequency + TIME*wave_speed*10.) * wave_amplitude;
	VERTEX.y += wave;
#else
	vertex_offset = VERTEX.xz;
	vert_hash = hash(uint(VERTEX_ID));
	VERTEX.y = (height(VERTEX.xz, TIME) - 0.5) * wave_amplitude*5.;
#endif
}

float get_water_depth(vec2 uv, in mat4 proj, in float vert_dist, in float frag_dist) {
	// Get depth at each pixel w.r.t. water mesh
    float depth = texture(depth_texture, uv).x;
	// depth = depth*2. - 1.; // OpenGL
    depth = proj[3][2] / (depth + proj[2][2]);
	depth = vert_dist + depth;
	return depth - frag_dist;
}

vec3 get_water_refraction_normal(in vec2 uv, in float time) {
	// We mix two normal maps to create a cross wave-like uv pattern
	vec3 refract0 = texture(refract_normal, uv*refract_scale.xy + time*refract_scale.z).xyz;
	vec3 refract1 = texture(refract_normal, uv*refract_scale.xy - time*refract_scale.z).xyz;
	return normalize(vec3(refract0.rg + refract1.rg, refract0.b * refract1.b));
}

void fragment() {
	// Called for every pixel the material is visible on.
#ifdef USE_FRESNEL
	float fresnel = min(sqrt(1.0 - dot(NORMAL, VIEW)), 1.0); // Fresnel reflectance approximation
#endif

	// --- REFRACTION ---
	// Refraction artifacts will still appear at sharp depth transitions, but because
	// the deep->shallow colors are more similar, the artifacting is less prnounced.
	vec3 water_refraction = get_water_refraction_normal(UV, TIME);
	// FIXME: idk why a corrective factor is needed
	vec2 refract_uv = ((water_refraction.xy - 0.56)*refract_factor);
	vec4 refract_color = texture(screen_texture, SCREEN_UV + refract_uv*0.2);

	// --- COLOR ---
	float water_depth = get_water_depth(SCREEN_UV + refract_uv*0.2, PROJECTION_MATRIX, VERTEX.z, FRAGCOORD.z);
	float depth_fade = clamp(water_depth / depth_factor, 0., 1.);
	vec4 water_color = mix(shallow_color, deep_color, depth_fade);

	// --- FOAM ---
	// Sample depth buffer at a lower distortion to remove glaring foam outline artifacts.
	float foam_depth = get_water_depth(SCREEN_UV + refract_uv*0.02, PROJECTION_MATRIX, VERTEX.z, FRAGCOORD.z) + 0.7;
	float foam_cutoff = clamp(foam_depth / foam_factor, 0., 1.);
	float foam_noise = texture(foam_noise_texture, UV*foam_scale.xy + TIME*foam_scale.z).x;
	vec4 foamed_water_color = mix(water_color, foam_color, step(foam_cutoff, foam_noise) * foam_color.a);
	ALBEDO = mix(refract_color, foamed_water_color, foamed_water_color.a).rgb;
#ifdef USE_FRESNEL
	ALBEDO += fresnel*0.1;
#endif

	// --- NORMAL ---
#ifdef SIMPLE_WAVES
	float depth_corrected_normal_strength = mix(0.0, normal_strength, depth_fade);
	NORMAL = vec3(water_refraction.rg * depth_corrected_normal_strength, mix(1., water_refraction.b, depth_corrected_normal_strength));
	NORMAL_MAP = water_refraction;
#else
	// FIXME: Why does this produce different results when calculated in the fragment shader?
	float k = height(vertex_offset, TIME) - height(vertex_offset + vec2(0.0, 0.1), TIME);
	NORMAL = normalize(vec3(k, (1.0 - normal_strength)*0.2, k));
#endif
#ifdef SEPARATE_FOAM_NORMAL
	NORMAL *= 1.0 - step(foam_cutoff, foam_noise);
#endif

	// --- REFLECTIONS ---
	RIM = 0.2;
	ROUGHNESS = roughness;
#ifdef USE_FRESNEL
	ROUGHNESS *= (1.0 - fresnel);
#endif
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
