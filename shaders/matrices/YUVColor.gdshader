shader_type spatial;

#include "res://shaders/shapes/basic.gdshaderinc"
#include "res://shaders/matrices/basic.gdshaderinc"

const mat3 yuv_2_rgb = mat3(
	vec3(1.0, 0.0, 1.13983),
	vec3(1.0, -0.39465, -0.58060),
	vec3(1.0, 2.03211, 0.0));
const mat3 rgb_2_yuv = mat3(
	vec3(0.2126, 0.7152, 0.0722),
	vec3(-0.09991, -0.33609, 0.43600),
	vec3(0.615, -0.5586, -0.05639));

void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);
	vec3 color = vec3(0.0);

	uv -= 0.5;
	uv *= 2.0;

	color = yuv_2_rgb * vec3(0.5, uv.x, uv.y);

	ALBEDO = color;
}
