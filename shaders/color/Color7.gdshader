shader_type spatial;

uniform vec3 influenced_color : source_color = vec3(0.548,0.565,0.542);
uniform vec3 influencing_color_A : source_color = vec3(0.295,0.295,0.295);
uniform vec3 influencing_color_B : source_color = vec3(0.904,0.947,0.965);

#include "res://shaders/shapes/basic.gdshaderinc"

void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);

	vec3 color = vec3(0.0);

	color = mix(influencing_color_A, influencing_color_B, uv.y);

	color = mix(color, influenced_color, rect(uv, vec2(0.0333, 0.37)));

	ALBEDO = color;
}
