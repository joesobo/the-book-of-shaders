shader_type spatial;

uniform vec3 influenced_color : source_color = vec3(0.745,0.678,0.539);
uniform vec3 influencing_color_a : source_color = vec3(0.653,0.918,0.985);
uniform vec3 influencing_color_b : source_color = vec3(0.980,0.576,0.113);

#include "res://shaders/shapes/basic.gdshaderinc"

void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);

	vec3 color = mix(influencing_color_a, influencing_color_b, step(0.5, uv.x));

	color = mix(color, influenced_color, rect(abs((uv - vec2(0.5, 0.0)) * vec2(2.0, 1.0)), vec2(0.05, 0.125)));

	ALBEDO = color;
}
