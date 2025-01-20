shader_type spatial;
render_mode unshaded, cull_disabled;

uniform float clearcoat_factor : hint_range(0, 5) = 2.0;
uniform sampler2D background_texture : source_color;
uniform sampler2D card_texture : source_color;
uniform sampler2D card_alpha_mask : source_color;
uniform sampler2D face_texture : source_color, repeat_disable;

void fragment() {
	const float aspect_ratio = 0.776; // Aspect ratio of card texture
	vec4 card_col = texture(background_texture, UV);
	vec4 bg_col = texture(card_texture, UV);
	vec4 face_col = texture(face_texture, UV*vec2(aspect_ratio, 1.0)*2.0 - vec2(0.27, 0.42));

	ALBEDO = mix(mix(card_col.rgb * card_col.a, face_col.rgb, face_col.a), bg_col.rgb, bg_col.a);
	ALBEDO *= NORMAL.y*clearcoat_factor + 1.0;

	ALPHA = texture(card_alpha_mask, UV).r;
}
