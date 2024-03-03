shader_type spatial;

// Source: https://www.shadertoy.com/view/4fSSDD
float sin_func(float x, float size, float speed) {
    return sign(sin(x * size + TIME * speed)) + 0.5;
}

void fragment() {
	    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = FRAGCOORD.xy/VIEWPORT_SIZE.xy;
    vec2 uv_n = FRAGCOORD.xy/VIEWPORT_SIZE.x;

    vec2 center = vec2(0.5, 0.5 * VIEWPORT_SIZE.y / VIEWPORT_SIZE.x);
    float radius = 0.2;
    
    vec2 delta = uv_n - center;
    
    float cos_theta = atan(delta.x, radius);
    float sin_theta = atan(delta.y, radius);
    float radial_theta = atan(delta.y, delta.x);
    
    float d = distance(center, uv_n);
    
    float cos_displ = sin(cos_theta * 15.0 + TIME*4.);
    float sin_displ = sin(sin_theta * 15.0 + TIME*4.);
    float radial_displ = sin(radial_theta * 15.0 + TIME*4.);
    
    float circ = step(d + (cos_displ * 0.01 * TIME) + (sin_displ * 0.01 * TIME) + (radial_displ * 0.01 * TIME), radius);

    // Output to screen
    ALBEDO = vec3(circ) * vec3(0.2);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
