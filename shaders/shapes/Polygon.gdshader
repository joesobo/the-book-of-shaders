shader_type spatial;

#include "res://shaders/shapes/basic.gdshaderinc"
#include "res://shaders/graph/basic.gdshaderinc"

uniform vec3 color_a : source_color = vec3(0.0, 0.6, 0.866);
uniform vec3 color_b : source_color = vec3(1.0, 0.6, 0.2);
uniform int sides : hint_range(3, 20) = 3;

void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);
	vec3 color = vec3(0.0);
	float d = 0.0;

	uv = uv * 2.0 - 1.0;

	float a = atan(uv.x, uv.y) + PI;
	float r = (2.0 * PI) / float(sides);

	d = cos(floor(0.5 + a / r) * r - a) * length(uv);

	float pct = 1.0 - smoothstep(0.4, 0.41, d);
	color = mix(color_a, color_b, pct);

	ALBEDO = color;
}
