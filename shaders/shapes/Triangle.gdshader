shader_type spatial;

uniform vec3 base_color : source_color = vec3(0.529, 0.808, 0.922);
uniform vec3 triangle_color : source_color = vec3(1.0, 0.647, 0.0);
uniform float triangle_size : hint_range(0.0, 1.0) = 0.5;

#include "res://shaders/shapes/basic.gdshaderinc"

void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);

	float triangle = tri(uv, triangle_size);

	vec3 color = mix(base_color, triangle_color, triangle);

	ALBEDO = color;
}
