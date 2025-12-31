shader_type spatial;

#include "res://shaders/color/basic.gdshaderinc"

void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);
	vec3 color = vec3(0.0);

	vec2 to_center = vec2(0.5) - uv;
	float angle = atan(to_center.y, to_center.x);
	float radius = length(to_center) * 2.0;

	color = hsb2rgb(vec3((angle / (2.0 * PI)) + 0.5, radius, 1.0));

	ALBEDO = color;
}
