shader_type spatial;

#include "res://shaders/shapes/basic.gdshaderinc"

uniform float line_width : hint_range(0.001, 0.05) = 0.025;
uniform vec3 color_a : source_color = vec3(0.0, 0.6, 0.866);
uniform vec3 color_b : source_color = vec3(1.0, 0.6, 0.2);

void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);
	vec3 color = color_b;

	float pct = circle(uv, 0.5);
	color = mix(color_a, color_b, pct);

	float line_1 = line(uv, vec2(0.5, 1.0), vec2(0.5, 0.0), line_width);
	color = mix(color, color_b, line_1);

	float line_2 = line(uv, vec2(0.5, 0.65), vec2(0.25, 0.9), line_width);
	color = mix(color, color_b, line_2);

	float line_3 = line(uv, vec2(0.5, 0.3), vec2(0.15, 0.65), line_width);
	color = mix(color, color_b, line_3);

	float line_4 = line(uv, vec2(0.5, 0.5), vec2(0.75, 0.75), line_width);
	color = mix(color, color_b, line_4);

	float line_5 = line(uv, vec2(0.5, 0.15), vec2(0.9, 0.55), line_width);
	color = mix(color, color_b, line_5);

	ALBEDO = color;
}
