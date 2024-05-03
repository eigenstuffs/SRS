shader_type canvas_item;
render_mode unshaded, blend_add;

#define RADIUS   (20.)
#define VARIANCE (15.)

global uniform float cpu_sync_time;
// `filter_linear` is used to halve the number of texture reads!
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

uniform float t0;
uniform float t1;
uniform vec2 direction;
uniform float strength; // Should be half of actual strength for two pass
uniform float duration;
uniform float start_time;

// Burmann series approximation for error function
// Source: https://en.wikipedia.org/wiki/Error_function
float erf(in float x) {
    float a = exp(-x*x);
	float p = sqrt(PI)*0.5;
    return sign(x)/p * sqrt(1.0 - a) * (p + 0.155*a - 0.042625*a*a);
}

// Gaussian with sigma correction
// Source: https://bartwronski.com/2021/10/31/practical-gaussian-filter-binomial-filter-and-small-sigma-gaussians/
float gaussian_sigma_corrected(in float x, in float sigma) {
	float a = sqrt(0.5) / sigma;
	return 0.5 * (erf((x + 0.5)*a) - erf((x - 0.5)*a));
}

void fragment() {
    vec2 sample_direction = direction * SCREEN_PIXEL_SIZE;
    vec3 col = vec3(0)
         + texture(screen_texture, SCREEN_UV + sample_direction * -19.4783549f).rgb * 0.0276007f
         + texture(screen_texture, SCREEN_UV + sample_direction * -17.4805725f).rgb * 0.0325260f
         + texture(screen_texture, SCREEN_UV + sample_direction * -15.4827910f).rgb * 0.0376559f
         + texture(screen_texture, SCREEN_UV + sample_direction * -13.4850100f).rgb * 0.0428279f
         + texture(screen_texture, SCREEN_UV + sample_direction * -11.4872297f).rgb * 0.0478531f
         + texture(screen_texture, SCREEN_UV + sample_direction *  -9.4894499f).rgb * 0.0525272f
         + texture(screen_texture, SCREEN_UV + sample_direction *  -7.4916705f).rgb * 0.0566433f
         + texture(screen_texture, SCREEN_UV + sample_direction *  -5.4938915f).rgb * 0.0600073f
         + texture(screen_texture, SCREEN_UV + sample_direction *  -3.4961126f).rgb * 0.0624526f
         + texture(screen_texture, SCREEN_UV + sample_direction *  -1.4983340f).rgb * 0.0638538f
         + texture(screen_texture, SCREEN_UV + sample_direction *   0.4994447f).rgb * 0.0641378f
         + texture(screen_texture, SCREEN_UV + sample_direction *   2.4972233f).rgb * 0.0632896f
         + texture(screen_texture, SCREEN_UV + sample_direction *   4.4950020f).rgb * 0.0613537f
         + texture(screen_texture, SCREEN_UV + sample_direction *   6.4927810f).rgb * 0.0584306f
         + texture(screen_texture, SCREEN_UV + sample_direction *   8.4905602f).rgb * 0.0546676f
         + texture(screen_texture, SCREEN_UV + sample_direction *  10.4883398f).rgb * 0.0502470f
         + texture(screen_texture, SCREEN_UV + sample_direction *  12.4861198f).rgb * 0.0453714f
         + texture(screen_texture, SCREEN_UV + sample_direction *  14.4839004f).rgb * 0.0402479f
         + texture(screen_texture, SCREEN_UV + sample_direction *  16.4816817f).rgb * 0.0350749f
         + texture(screen_texture, SCREEN_UV + sample_direction *  18.4794636f).rgb * 0.0300289f
         + texture(screen_texture, SCREEN_UV + sample_direction *  20.0000000f).rgb * 0.0132029f;

	float t = mix(t0, t1, min(1.0, (cpu_sync_time - start_time) / duration));
    COLOR.rgb = col * strength*t;
}