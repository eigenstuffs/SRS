// Source: https://raw.githubusercontent.com/lukky-nl/custom_post_processing_effects_godot_4.2/main/shaders/post_processing_effects/spatial/base_shader.gdshader
shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture, filter_linear_mipmap;
uniform sampler2D DEPTH_TEXTURE : source_color, hint_depth_texture;

uniform float depth_range : hint_range(0.1, 100.0, 0.1);

void vertex(){
	POSITION = vec4(VERTEX, 1.0); // BASICALLY YOU ONLY NEED THIS LINE
}

void fragment() {
	vec2 uv = SCREEN_UV;

	vec3 screen_color = texture(SCREEN_TEXTURE, uv).rgb;
	vec3 normal = texture(NORMAL_TEXTURE, uv).rgb;
	float roughness =  texture(NORMAL_TEXTURE, uv).w;

	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z / depth_range;

	// your code goes here!


	// example outputs

	//ALBEDO = vec3(linear_depth); 	// showing depth texture
	//ALBEDO = normal; 				// showing normal texture
	//ALBEDO = vec3(roughness); 	// showing roughness texture
	//ALBEDO = screen_color;		// showing screen texture
}