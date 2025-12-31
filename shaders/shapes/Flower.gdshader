shader_type spatial;

#include "res://shaders/shapes/basic.gdshaderinc"
#include "res://shaders/graph/basic.gdshaderinc"

uniform int flower_mode : hint_enum("Three", "Six", "Five", "Eighteen", "Gear") = 0;
uniform vec3 color_a : source_color = vec3(0.0, 0.6, 0.866);
uniform vec3 color_b : source_color = vec3(1.0, 0.6, 0.2);

void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);
	vec3 color = vec3(0.0);

	vec2 pos = vec2(0.5) - uv;

	float r = length(pos) * 2.0;
	float a = atan(pos.y, pos.x);

	float f;
	switch (flower_mode) {
		case 0: // Three
			f = cos(a * 3.0);
			break;
		case 1: // Six
			f = abs(cos(a * 3.0));
			break;
		case 2: // Five
			f = abs(cos(a * 2.5)) * 0.5 + 0.3;
			break;
		case 3: // Eighteen
			f = abs(cos(a * 12.0) * sin(a * 3.0)) * 0.8 + 0.1;
			break;
		case 4: // Gear
			f = smoothstep(-0.5, 1.0, cos(a * 10.0)) * 0.2 + 0.5;
			break;
	}

	vec3 pct = vec3(1.0 - smoothstep(f, f + 0.02, r));
	color = mix(color_a, color_b, pct);

	ALBEDO = color;
}
