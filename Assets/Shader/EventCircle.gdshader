shader_type canvas_item;


uniform float radius = 0.2;
uniform float progress = 0.5;

void fragment() {
	COLOR = vec4(1.0, 0.0, 0.0, 1.0) * float(pow(0.5 - UV.x, 2) + pow(0.5 - UV.y, 2) < radius);
//	COLOR = 
}
	