shader_type canvas_item;
/** NOTE: i hardcoded the parameters/colors for this shader because im lazy--sorry! */

#define THICKNESS 0.3
#define SPEED 4.0
#define STRENGTH 0.2

global uniform float cpu_sync_time;

uniform float start_time;
uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {

    vec2 uv = FRAGCOORD.xy * SCREEN_PIXEL_SIZE;
    float time = (cpu_sync_time - start_time)*SPEED;

    float strength = STRENGTH * max(0.0, 1.0+THICKNESS - time);

    // --- SHOCKWAVE ---
    float dist = length((FRAGCOORD.xy - 0.5/SCREEN_PIXEL_SIZE)*SCREEN_PIXEL_SIZE.y);
    float shockwave = smoothstep(dist + THICKNESS*0.5, dist - THICKNESS*0.5, time);
    float shockwave_offset = shockwave*(1.0 - shockwave) * strength*2.0;
    
    // --- SCREEN SHAKE ---
    float phase = time*35.0*strength*SPEED;
    vec2 screen_shake_offset = vec2(sin(phase), cos(phase)) * strength*0.05;
    
    // --- FLASH ---
    vec3 flash = vec3(0.3, 0.3, 0.4) * strength*(1.0 - dist)*3.0;
	
    COLOR.rgb = texture(screen_texture, SCREEN_UV - shockwave_offset + screen_shake_offset).rgb + flash;
}