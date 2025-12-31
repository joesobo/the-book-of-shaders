shader_type spatial;

uniform vec3 influenced_color : source_color = vec3(0.515,0.435,0.415);
uniform vec3 influencing_color_A : source_color = vec3(0.325,0.278,0.209);
uniform vec3 influencing_color_B : source_color = vec3(0.497,0.364,0.565);

#include "res://shaders/shapes/basic.gdshaderinc"

void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);

	vec3 color = vec3(0.0);

	color = mix(influencing_color_A, influencing_color_B, step(0.5, uv.y));

	color = mix(color, influenced_color, rect(abs((uv - vec2(0.0, 0.5)) * vec2(1.0, 2.0)), vec2(0.01, 0.04)));

	ALBEDO = color;
}
