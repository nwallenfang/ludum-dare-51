shader_type canvas_item;

uniform float progress = 0.0;

uniform vec4 fill_color: hint_color;
uniform vec4 progress_color: hint_color;
uniform sampler2D bar_sprite;

void fragment() {
	COLOR = texture(bar_sprite, UV) * vec4(0.0, 0.0, 0.0, 1.0);
}