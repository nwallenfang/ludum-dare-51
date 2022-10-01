shader_type canvas_item;

uniform float progress = 0.0;

uniform vec4 fill_color: hint_color;
uniform vec4 progress_color: hint_color;
uniform sampler2D bar_sprite;

void fragment() {
	float progress_t = 1.0 * progress;
	COLOR = float(UV.x < progress_t) * texture(bar_sprite, UV) * progress_color + float(UV.x >= progress_t) * texture(bar_sprite, UV) * fill_color;
}