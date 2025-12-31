shader_type spatial;

#include "res://shaders/shapes/basic.gdshaderinc"

void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);
	vec3 color = vec3(0.0);

	float pct = box_outline(uv, vec2(0.5, 0.5), vec2(0.5, 0.8), 0.05);

	color = vec3(pct);

	ALBEDO = color;
}
