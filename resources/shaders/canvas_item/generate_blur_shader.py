import math
import argparse

parser = argparse.ArgumentParser('generate_blur_shader')
parser.add_argument('radius', help='The radius of the blur.', type=int)
parser.add_argument('sigma', help='The variance of the gaussian distribution.', type=int)
args = parser.parse_args()

# Source: https://bartwronski.com/2021/10/31/practical-gaussian-filter-binomial-filter-and-small-sigma-gaussians/
def gaussian_sigma_corrected(x): return (math.erf((x+0.5)*math.sqrt(0.5) / args.sigma) - math.erf((x-0.5)*math.sqrt(0.5) / args.sigma))*0.5
def generate_shader(weights, offsets, filename):
    samples = '\n'.join([f'             + texture(screen_texture, SCREEN_UV + sample_direction * {offsets[i].rjust(len(offsets[0]))}f).rgb * {weights[i]}f' for i in range(len(offsets))])
    with open(filename, 'w') as f:
        f.write(f'''shader_type canvas_item;
render_mode unshaded;

#define RADIUS   ({args.radius}.)
#define VARIANCE ({args.sigma}.)

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
float erf(in float x) {{
    float a = exp(-x*x);
	float p = sqrt(PI)*0.5;
    return sign(x)/p * sqrt(1.0 - a) * (p + 0.155*a - 0.042625*a*a);
}}

// Gaussian with sigma correction
// Source: https://bartwronski.com/2021/10/31/practical-gaussian-filter-binomial-filter-and-small-sigma-gaussians/
float gaussian_sigma_corrected(in float x, in float sigma) {{
	float a = sqrt(0.5) / sigma;
	return 0.5 * (erf((x + 0.5)*a) - erf((x - 0.5)*a));
}}

void fragment() {{
    vec2 sample_direction = direction * SCREEN_PIXEL_SIZE;
    vec3 col = vec3(0);

	float t = mix(t0, t1, min(1.0, (cpu_sync_time - start_time) / duration));
	if (t >= 1.0) {{ // Use precomputed weights and offsets
		col += vec3(0)
{samples};
	}} else {{ // Dynamically compute weights and offsets
        // Transition for radius and variance is non-linear 
		float radius = floor(RADIUS*(1.-pow(1.-t, 2)));
		float variance = max(1.0, VARIANCE*t*t*(2.-t));

        // Normalization factor for gaussian weights
        // Source: https://www.wolframalpha.com/input?i2d=true&i=Sum%5BDivide%5B1%2C2%5D%5C%2840%29erf%5C%2840%29Divide%5Bn%2B0.5%2Cs%5DSqrt%5B0.5%5D%5C%2841%29-erf%5C%2840%29Divide%5Bn-0.5%2Cs%5DSqrt%5B0.5%5D%5C%2841%29%2C%7Bn%2C-x%2Cx%7D%5D
        float n = 1.0 / erf((2.0*radius + 1.0) / (2.0*sqrt(2.0) * variance));
        for (int i = 0; i < int(radius); i++) {{
            float j = float(i*2) - radius;
            float g0 = gaussian_sigma_corrected(j+0.0, variance);
            float g1 = gaussian_sigma_corrected(j+1.0, variance);
            float gm = g0 + g1;
            col += texture(screen_texture, SCREEN_UV + sample_direction * (j+g1/gm)).rgb * gm*n;
        }}
        col += texture(screen_texture, SCREEN_UV + sample_direction * radius).rgb * gaussian_sigma_corrected(radius, variance)*n;	
    }}
    COLOR.rgb = col;
}}''')


weights = []
offsets = []
n = math.erf((2*args.radius + 1)/(2*math.sqrt(2)*args.sigma))
for i in range(-args.radius, args.radius, 2):
    g0 = gaussian_sigma_corrected(i + 0)
    g1 = gaussian_sigma_corrected(i + 1)
    offsets.append(format(i + g1/(g0 + g1), '.7f'))
    weights.append(format((g0 + g1)/n, '.7f'))
weights.append(format(gaussian_sigma_corrected(args.radius)/n, '.7f'))
offsets.append(format(args.radius, '.7f'))

generate_shader(weights, offsets, 'blur.gdshader')