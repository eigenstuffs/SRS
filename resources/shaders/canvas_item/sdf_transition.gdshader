shader_type canvas_item;
render_mode unshaded;

#define STAR_SDF 0

global uniform float cpu_sync_time;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec4 color_override : source_color = vec4(0,0,0,1);
uniform bool use_star_sdf = false;
uniform float start_radius = 1.0;
uniform float end_radius = 0.0;
uniform float duration = 1.0;
uniform float start_time = 0.0;

// Source: https://raw.githubusercontent.com/glslify/glsl-easings/master/quartic-in-out.glsl
float quarticInOut(float t) {
  return t < 0.5 ? 8.0 * pow(t, 4.0) : -8.0 * pow(t - 1.0, 4.0) + 1.0;
}

// Source: https://iquilezles.org/articles/distfunctions2d/
float sdf(in vec2 p, in float r) {
	if (use_star_sdf) {
	    vec2 acs = vec2(0.80901, 0.58778);
	    vec2 ecs = vec2(0.54030, 0.84147);
	    p.x = abs(p.x);
	    
	    // reduce to first sector
	    float bn = mod(atan(p.x, p.y), 0.4*PI) - 0.2*PI;
	    p = length(p) * vec2(cos(bn), abs(sin(bn)));

	    // line sdf
	    r *= 2.15;
	    p -= r*acs;
	    p += ecs*clamp(-dot(p,ecs), 0.0, r*acs.y/ecs.y);
	    return length(p) * sign(p.x);
	} else {
	    return length(p) - r;
	}
}

void fragment() {
	float aspect_ratio = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
	vec2 p = (2.0*UV - 1.0) * vec2(aspect_ratio, 1);
	float t = 1.0 - min(1.0, ((cpu_sync_time - start_time)/(abs(start_radius-end_radius)*duration)));
	// We take diagonal length of aspect ratio for diameter correction (for circle sdf)
	float radius = sqrt(1.1 + aspect_ratio*aspect_ratio)*mix(end_radius, start_radius, quarticInOut(t));
	float d = sdf(p, radius);
	
	// Multiply anti-aliasing factor by radius to 'sharpen' image for small radii 
    COLOR = mix(texture(screen_texture, SCREEN_UV), color_override, 1.0-smoothstep(0.0,0.01*radius,-d));
}