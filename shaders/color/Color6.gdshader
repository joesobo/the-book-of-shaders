shader_type spatial;

uniform vec3 influenced_color : source_color = vec3(0.745,0.696,0.529);
uniform vec3 influencing_color_A : source_color = vec3(0.418,0.735,0.780);
uniform vec3 influencing_color_a : source_color = vec3(0.065,0.066,0.290);
uniform vec3 influencing_color_b : source_color = vec3(0.865,0.842,0.162);
uniform vec3 influencing_color_B : source_color = vec3(0.980,0.603,0.086);

#include "res://shaders/shapes/basic.gdshaderinc"

void fragment() {
	vec2 uv = vec2(UV.x, UV.y);

	vec3 color = mix(mix(influencing_color_A, influencing_color_a, step(0.3, uv.y)), mix(influencing_color_b, influencing_color_B, step(0.7, uv.y)), step(0.5, uv.y));
	color = mix(color, influenced_color, rect(abs((uv - vec2(0.0, 0.5)) * vec2(1.0, 1.75)), vec2(0.025, 0.09)));

	ALBEDO = color;
}
