shader_type spatial;

#include "res://shaders/color/basic.gdshaderinc"

void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);
	vec3 color = vec3(0.0);

	// We map x (0.0 - 1.0) to the hue (0.0 - 1.0)
	// And the y (0.0 - 1.0) to the brightness
	color = hsb2rgb(vec3(uv.x, 1.0, uv.y));

	ALBEDO = color;
}
