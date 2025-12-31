shader_type spatial;

uniform vec3 color_a : source_color = vec3(0.149,0.141,0.912);
uniform vec3 color_b : source_color = vec3(1.000,0.833,0.224);

#include "res://shaders/math/bezier.gdshaderinc"
#include "res://shaders/graph/basic.gdshaderinc"

void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);
	vec3 color = vec3(0.0);

	vec3 pct = vec3(uv.x);

	pct.r = smoothstep(0.0, 1.0, pct.r);
	pct.g = sin(uv.x * PI);
	pct.b = quadratic_bezier(uv.x, 0.85, 0.15);

	color = mix(color_a, color_b, pct);

	color = mix(color, vec3(1.0, 0.0, 0.0), plot(uv, pct.r));
	color = mix(color, vec3(0.0, 1.0, 0.0), plot(uv, pct.g));
	color = mix(color, vec3(0.0, 0.0, 1.0), plot(uv, pct.b));

	ALBEDO = color;
}
