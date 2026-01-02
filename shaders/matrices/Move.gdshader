shader_type spatial;

uniform int bounce_count : hint_range(1, 20) = 4;
uniform float bounce_scale : hint_range(0.0, 2.0) = 0.5;
uniform float plus_size : hint_range(0.01, 1.0) = 0.25;

#include "res://shaders/shapes/basic.gdshaderinc"
#include "res://shaders/math/custom.gdshaderinc"

void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);
	vec3 color = vec3(0.0);

	// Use mod to keep time cycling, scale to control speed
	float bounce_value = bounce(mod(TIME * 0.5, 1.0), bounce_count);

	// Scale and center the bounce movement
	vec2 translate = vec2(0.0, (bounce_value - 0.5) * bounce_scale);
	uv -= translate;

	color = vec3(uv.x, uv.y, 0.0);

	color += vec3(plus(uv, plus_size));

	ALBEDO = color;
}
