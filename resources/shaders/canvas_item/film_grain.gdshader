shader_type canvas_item;
render_mode unshaded;

uniform sampler2DArray noise_textures : repeat_enable;
uniform float noise_strength : hint_range(0, 1) = 0.055;
uniform int updates_per_second = 24;

void fragment() {
	ivec3 uv = ivec3(vec3(SCREEN_UV / SCREEN_PIXEL_SIZE, TIME * float(updates_per_second))) % textureSize(noise_textures, 0);
	
	COLOR.rgb = vec3(0);
	COLOR.a = texelFetch(noise_textures, uv, 0).r * noise_strength;
}