shader_type spatial;
render_mode skip_vertex_transform;

varying vec3 world_pos;

instance uniform vec4 color_overwrite : source_color = vec4(0.); // Alpha channel is mix factor
instance uniform float alpha_overwrite = 1.0;
instance uniform vec3 fade_in_position;
instance uniform vec3 fade_out_position;
instance uniform vec3 fade_plane_normal;
instance uniform float fade_in_distance = 1.0;
instance uniform float fade_out_distance = 1.0;

uniform sampler2D tex;
uniform vec3 miss_color : source_color = vec3(0.25, 0.085, 0.05);

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
		
    VERTEX = (VIEW_MATRIX * vec4(world_pos, 1.0)).xyz;
	VERTEX.x += (pow(2.2, -(world_pos.z + 3.0)*0.75) * sin(world_pos.z*0.75)) * 0.05;
}

void fragment() {
	vec4 tex_color = texture(tex, UV);
	float fade_in_factor = distance(fade_in_position, world_pos) / fade_in_distance * dot(fade_in_position - world_pos, fade_plane_normal);
	float fade_out_factor = distance(fade_out_position, world_pos) / fade_out_distance * dot(fade_out_position - world_pos, fade_plane_normal);
	fade_in_factor = smoothstep(0., 1., fade_in_factor);
	fade_out_factor = smoothstep(0., 1., fade_out_factor);
	
	// Color swap from luminance
    vec3 greyscale = vec3((tex_color.r + tex_color.g + tex_color.b) * 0.3333333);
    float mix_factor = (greyscale.x < 0.5) ? 1.0 : 0.0;
	ALBEDO = mix(pow(tex_color.rgb, vec3(2.2)), greyscale * color_overwrite.rgb, mix_factor * color_overwrite.a);
	if (greyscale.x > 0.5 && greyscale.x < 0.95) ALBEDO = vec3(0.6, 0.6, 0.6);
	
	ALBEDO = mix(ALBEDO, miss_color, 1. - alpha_overwrite);
	ALPHA *= tex_color.a * fade_in_factor * (1. - fade_out_factor) * alpha_overwrite;
}

//void light() {
	 // Called for every pixel for every light affecting the material.
	 // Uncomment to replace the default light processing function with this one.
//}
