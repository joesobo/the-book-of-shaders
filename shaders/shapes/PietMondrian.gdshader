shader_type spatial;

#include "res://shaders/shapes/basic.gdshaderinc"

uniform vec3 color_a : source_color = vec3(0.965, 0.937, 0.866);
uniform vec3 color_b : source_color = vec3(0.102, 0.114, 0.133);

uniform vec3 color_c : source_color = vec3(0.705, 0.133, 0.137);
uniform vec3 color_d : source_color = vec3(1.0, 0.78, 0.173);
uniform vec3 color_e : source_color = vec3(0.010, 0.376, 0.616);

void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);
	vec3 color = color_a;

	float fill = rect(uv, vec2(0.0, 1.0), vec2(0.4, 0.6));
	float outline = rect_outline(uv, vec2(0.0, 1.0), vec2(0.4, 0.6), 0.025);

	color = mix(color, color_c, fill);
	color = mix(color, color_b, outline);

	float fill_2 = rect(uv, vec2(1.0, 0.0), vec2(0.4, 0.2));
	float outline_2 = rect_outline(uv, vec2(1.0, 0.0), vec2(0.4, 0.2), 0.025);

	color = mix(color, color_e, fill_2);
	color = mix(color, color_b, outline_2);

	float fill_3 = rect(uv, vec2(1.0, 1.0), vec2(0.1, 0.6));
	float outline_3 = rect_outline(uv, vec2(1.0, 1.0), vec2(0.1, 0.6), 0.025);

	color = mix(color, color_d, fill_3);
	color = mix(color, color_b, outline_3);

	float outline_4 = rect_outline(uv, vec2(0.885, 0.5), vec2(0.175, 1.1), 0.025);
	color = mix(color, color_b, outline_4);

	float outline_5 = rect_outline(uv, vec2(0.5, 0.785), vec2(1.1, 0.175), 0.025);
	color = mix(color, color_b, outline_5);

	float outline_6 = rect_outline(uv, vec2(0.125, 0.875), vec2(0.15, 0.35), 0.025);
	color = mix(color, color_b, outline_6);

	float outline_7 = rect_outline(uv, vec2(0.5, 0.475), vec2(0.635, 0.8), 0.025);
	color = mix(color, color_b, outline_7);

	float outline_8 = rect_outline(uv, vec2(0.5, 0.0), vec2(0.635, 0.2), 0.025);
	color = mix(color, color_b, outline_8);

	ALBEDO = color;
}
