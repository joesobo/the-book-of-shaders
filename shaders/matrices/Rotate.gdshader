shader_type spatial;

#include "res://shaders/shapes/basic.gdshaderinc"
#include "res://shaders/matrices/basic.gdshaderinc"

void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);
	vec3 color = vec3(0.0);

	// move space from center to origin before rotating to rotate around center of shape
	uv -= vec2(0.5);
	uv = rotate2d(sin(TIME) * PI) * uv;
	uv += vec2(0.5);

	color = vec3(uv.x, uv.y, 0.0);

	color += vec3(plus(uv, 0.5));

	ALBEDO = color;
}
