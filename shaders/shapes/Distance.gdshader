shader_type spatial;

#include "res://shaders/shapes/basic.gdshaderinc"
#include "res://shaders/math/custom.gdshaderinc"

uniform vec2 center = vec2(0.5);
uniform float heartbeat_speed : hint_range(0.0, 10.0) = 2.0;
uniform float circle_radius : hint_range(0.0, 1.0) = 0.5;
uniform vec3 color_a : source_color = vec3(0.0, 0.6, 0.866);
uniform vec3 color_b : source_color = vec3(1.0, 0.6, 0.2);

void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);
	float pct = 0.0;

	float heartbeat_value = heartbeat(TIME);
	float heartbeat_radius = (heartbeat_value - 0.1);

	pct = 1.0 - circle(uv, circle_radius + heartbeat_radius, center);

	vec3 color = mix(color_a, color_b, pct);

	ALBEDO = color;
}
