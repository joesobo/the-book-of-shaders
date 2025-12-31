shader_type spatial;

#include "res://shaders/shapes/basic.gdshaderinc"

uniform int distance_mode : hint_enum("Normal", "Min", "Max") = 0;
uniform int draw_mode : hint_enum("Fract", "Step", "Double Step", "Smoothstep") = 0;

void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);
	vec3 color = vec3(0.0);
	float d = 0.0;

	uv = uv * 2.0 - 1.0;

	// Distance field calculation based on distance_mode
	switch (distance_mode) {
		case 0: // Normal
			d = length(abs(uv) - 0.3);
			break;
		case 1: // Min
			d = length(min(abs(uv) - 0.3, 0.0));
			break;
		case 2: // Max
			d = length(max(abs(uv) - 0.3, 0.0));
			break;
	}

	// Drawing method based on draw_mode
	switch (draw_mode) {
		case 0: // Fract
			ALBEDO = vec3(fract(d * 10.0));
			break;
		case 1: // Step
			ALBEDO = vec3(step(0.3, d));
			break;
		case 2: // Double Step
			ALBEDO = vec3(step(0.3, d) * step(d, 0.4));
			break;
		case 3: // Smoothstep
			ALBEDO = vec3(smoothstep(0.3, 0.4, d) * smoothstep(0.6, 0.5, d));
			break;
	}
}
