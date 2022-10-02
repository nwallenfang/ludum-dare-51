shader_type canvas_item;

uniform vec2 scale;
uniform sampler2D noise;
uniform float speed = 0.2;
uniform vec2 direction = vec2(-0.1, 0.9);
uniform vec4 mod_color: hint_color;
uniform vec4 mod_color_2: hint_color;

void fragment() {
	COLOR.rgb = mix(mod_color.rgb, mod_color_2.rgb, 0.5 + 0.5 * sin(1.5 * TIME)) * vec3(texture(noise, scale * UV + speed * TIME * direction).r);
//	COLOR.a = 0.2 * float(UV.y < 0.1 || UV.y >= 0.5) + 0.6 * float(UV.y >= 0.1 && UV.y < 0.5);
//	COLOR.a = 0.5;
}