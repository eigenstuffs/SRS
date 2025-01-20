shader_type canvas_item;
render_mode unshaded;

#define RADIUS   (64.)
#define VARIANCE (64.)

global uniform float cpu_sync_time;
// `filter_linear` is used to halve the number of texture reads!
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

uniform float t0;
uniform float t1;
uniform vec2 direction;
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
    vec3 col = vec3(0);

	float t = mix(t0, t1, min(1.0, (cpu_sync_time - start_time) / duration));
	if (t >= 1.0) { // Use precomputed weights and offsets
		col += vec3(0)
             + texture(screen_texture, SCREEN_UV + sample_direction * -63.4961244f).rgb * 0.0111015f
             + texture(screen_texture, SCREEN_UV + sample_direction * -61.4962465f).rgb * 0.0114454f
             + texture(screen_texture, SCREEN_UV + sample_direction * -59.4963685f).rgb * 0.0117886f
             + texture(screen_texture, SCREEN_UV + sample_direction * -57.4964906f).rgb * 0.0121301f
             + texture(screen_texture, SCREEN_UV + sample_direction * -55.4966127f).rgb * 0.0124694f
             + texture(screen_texture, SCREEN_UV + sample_direction * -53.4967347f).rgb * 0.0128057f
             + texture(screen_texture, SCREEN_UV + sample_direction * -51.4968568f).rgb * 0.0131381f
             + texture(screen_texture, SCREEN_UV + sample_direction * -49.4969789f).rgb * 0.0134661f
             + texture(screen_texture, SCREEN_UV + sample_direction * -47.4971009f).rgb * 0.0137888f
             + texture(screen_texture, SCREEN_UV + sample_direction * -45.4972230f).rgb * 0.0141054f
             + texture(screen_texture, SCREEN_UV + sample_direction * -43.4973450f).rgb * 0.0144152f
             + texture(screen_texture, SCREEN_UV + sample_direction * -41.4974671f).rgb * 0.0147175f
             + texture(screen_texture, SCREEN_UV + sample_direction * -39.4975892f).rgb * 0.0150114f
             + texture(screen_texture, SCREEN_UV + sample_direction * -37.4977112f).rgb * 0.0152962f
             + texture(screen_texture, SCREEN_UV + sample_direction * -35.4978333f).rgb * 0.0155713f
             + texture(screen_texture, SCREEN_UV + sample_direction * -33.4979554f).rgb * 0.0158358f
             + texture(screen_texture, SCREEN_UV + sample_direction * -31.4980774f).rgb * 0.0160891f
             + texture(screen_texture, SCREEN_UV + sample_direction * -29.4981995f).rgb * 0.0163304f
             + texture(screen_texture, SCREEN_UV + sample_direction * -27.4983216f).rgb * 0.0165593f
             + texture(screen_texture, SCREEN_UV + sample_direction * -25.4984436f).rgb * 0.0167749f
             + texture(screen_texture, SCREEN_UV + sample_direction * -23.4985657f).rgb * 0.0169768f
             + texture(screen_texture, SCREEN_UV + sample_direction * -21.4986878f).rgb * 0.0171643f
             + texture(screen_texture, SCREEN_UV + sample_direction * -19.4988098f).rgb * 0.0173370f
             + texture(screen_texture, SCREEN_UV + sample_direction * -17.4989319f).rgb * 0.0174943f
             + texture(screen_texture, SCREEN_UV + sample_direction * -15.4990540f).rgb * 0.0176358f
             + texture(screen_texture, SCREEN_UV + sample_direction * -13.4991760f).rgb * 0.0177611f
             + texture(screen_texture, SCREEN_UV + sample_direction * -11.4992981f).rgb * 0.0178698f
             + texture(screen_texture, SCREEN_UV + sample_direction *  -9.4994202f).rgb * 0.0179616f
             + texture(screen_texture, SCREEN_UV + sample_direction *  -7.4995422f).rgb * 0.0180363f
             + texture(screen_texture, SCREEN_UV + sample_direction *  -5.4996643f).rgb * 0.0180937f
             + texture(screen_texture, SCREEN_UV + sample_direction *  -3.4997864f).rgb * 0.0181335f
             + texture(screen_texture, SCREEN_UV + sample_direction *  -1.4999084f).rgb * 0.0181556f
             + texture(screen_texture, SCREEN_UV + sample_direction *   0.4999695f).rgb * 0.0181600f
             + texture(screen_texture, SCREEN_UV + sample_direction *   2.4998474f).rgb * 0.0181467f
             + texture(screen_texture, SCREEN_UV + sample_direction *   4.4997253f).rgb * 0.0181158f
             + texture(screen_texture, SCREEN_UV + sample_direction *   6.4996033f).rgb * 0.0180672f
             + texture(screen_texture, SCREEN_UV + sample_direction *   8.4994812f).rgb * 0.0180011f
             + texture(screen_texture, SCREEN_UV + sample_direction *  10.4993591f).rgb * 0.0179178f
             + texture(screen_texture, SCREEN_UV + sample_direction *  12.4992371f).rgb * 0.0178175f
             + texture(screen_texture, SCREEN_UV + sample_direction *  14.4991150f).rgb * 0.0177005f
             + texture(screen_texture, SCREEN_UV + sample_direction *  16.4989929f).rgb * 0.0175670f
             + texture(screen_texture, SCREEN_UV + sample_direction *  18.4988709f).rgb * 0.0174176f
             + texture(screen_texture, SCREEN_UV + sample_direction *  20.4987488f).rgb * 0.0172525f
             + texture(screen_texture, SCREEN_UV + sample_direction *  22.4986267f).rgb * 0.0170724f
             + texture(screen_texture, SCREEN_UV + sample_direction *  24.4985047f).rgb * 0.0168776f
             + texture(screen_texture, SCREEN_UV + sample_direction *  26.4983826f).rgb * 0.0166688f
             + texture(screen_texture, SCREEN_UV + sample_direction *  28.4982605f).rgb * 0.0164465f
             + texture(screen_texture, SCREEN_UV + sample_direction *  30.4981385f).rgb * 0.0162113f
             + texture(screen_texture, SCREEN_UV + sample_direction *  32.4980164f).rgb * 0.0159639f
             + texture(screen_texture, SCREEN_UV + sample_direction *  34.4978943f).rgb * 0.0157049f
             + texture(screen_texture, SCREEN_UV + sample_direction *  36.4977723f).rgb * 0.0154350f
             + texture(screen_texture, SCREEN_UV + sample_direction *  38.4976502f).rgb * 0.0151550f
             + texture(screen_texture, SCREEN_UV + sample_direction *  40.4975281f).rgb * 0.0148655f
             + texture(screen_texture, SCREEN_UV + sample_direction *  42.4974061f).rgb * 0.0145673f
             + texture(screen_texture, SCREEN_UV + sample_direction *  44.4972840f).rgb * 0.0142612f
             + texture(screen_texture, SCREEN_UV + sample_direction *  46.4971620f).rgb * 0.0139479f
             + texture(screen_texture, SCREEN_UV + sample_direction *  48.4970399f).rgb * 0.0136281f
             + texture(screen_texture, SCREEN_UV + sample_direction *  50.4969178f).rgb * 0.0133027f
             + texture(screen_texture, SCREEN_UV + sample_direction *  52.4967958f).rgb * 0.0129724f
             + texture(screen_texture, SCREEN_UV + sample_direction *  54.4966737f).rgb * 0.0126379f
             + texture(screen_texture, SCREEN_UV + sample_direction *  56.4965516f).rgb * 0.0123001f
             + texture(screen_texture, SCREEN_UV + sample_direction *  58.4964296f).rgb * 0.0119596f
             + texture(screen_texture, SCREEN_UV + sample_direction *  60.4963075f).rgb * 0.0116172f
             + texture(screen_texture, SCREEN_UV + sample_direction *  62.4961855f).rgb * 0.0112735f
             + texture(screen_texture, SCREEN_UV + sample_direction *  64.0000000f).rgb * 0.0055077f;
	} else { // Dynamically compute weights and offsets
        // Transition for radius and variance is non-linear
		float radius = floor(RADIUS*(1.-pow(1.-t, 2)));
		float variance = max(1.0, VARIANCE*t*t*(2.-t));

        // Normalization factor for gaussian weights
        // Source: https://www.wolframalpha.com/input?i2d=true&i=Sum%5BDivide%5B1%2C2%5D%5C%2840%29erf%5C%2840%29Divide%5Bn%2B0.5%2Cs%5DSqrt%5B0.5%5D%5C%2841%29-erf%5C%2840%29Divide%5Bn-0.5%2Cs%5DSqrt%5B0.5%5D%5C%2841%29%2C%7Bn%2C-x%2Cx%7D%5D
        float n = 1.0 / erf((2.0*radius + 1.0) / (2.0*sqrt(2.0) * variance));
        for (int i = 0; i < int(radius); i++) {
            float j = float(i*2) - radius;
            float g0 = gaussian_sigma_corrected(j+0.0, variance);
            float g1 = gaussian_sigma_corrected(j+1.0, variance);
            float gm = g0 + g1;
            col += texture(screen_texture, SCREEN_UV + sample_direction * (j+g1/gm)).rgb * gm*n;
        }
        col += texture(screen_texture, SCREEN_UV + sample_direction * radius).rgb * gaussian_sigma_corrected(radius, variance)*n;
    }
    COLOR.rgb = col;
}