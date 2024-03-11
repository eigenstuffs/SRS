shader_type canvas_item;

void fragment() {
	COLOR.a = step(length(UV - 0.5), 0.5);
}
