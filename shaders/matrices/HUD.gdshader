shader_type spatial;

#include "res://shaders/math/custom.gdshaderinc"
#include "res://shaders/shapes/basic.gdshaderinc"
#include "res://shaders/matrices/basic.gdshaderinc"

uniform vec3 color_a : source_color = vec3(0.0, 0.6, 0.866);
uniform vec3 color_b : source_color = vec3(0.74,0.95,1.00);
uniform vec3 color_c : source_color = vec3(0.87,0.98,1.00);
uniform vec3 color_d : source_color = vec3(0.35,0.76,0.83);
uniform vec3 color_e : source_color = vec3(1.00,0.38,0.227);

uniform float blue_circle_radius_0 : hint_range(0.0, 1.0) = 0.01;
uniform float blue_circle_radius_1 : hint_range(0.0, 1.0) = 0.15;
uniform float blue_circle_radius_2 : hint_range(0.0, 1.0) = 0.25;
uniform float white_circle_radius : hint_range(0.0, 1.0) = 0.35;
uniform float dashed_circle_radius : hint_range(0.0, 1.0) = 0.45;
uniform float partial_circle_radius : hint_range(0.0, 1.0) = 0.37;
uniform float triangle_size : hint_range(0.0, 0.1) = 0.02;
uniform float triangle_movement : hint_range(0.0, 0.1) = 0.025;
uniform float moving_line_speed : hint_range(0.0, 2.0) = 1.0;
uniform float inner_circle_thickness : hint_range(0.0, 0.1) = 0.005;
uniform float outer_circle_thickness : hint_range(0.0, 0.1) = 0.01;
uniform float moving_line_thickness : hint_range(0.0, 0.1) = 0.005;

void rotate(inout vec2 uv, float degrees) {
	uv -= vec2(0.5);
	uv = rotate2d(degrees * PI / 180.0) * uv;
	uv += vec2(0.5);
}

void reset_rotation(inout vec2 uv, float degrees) {
	uv -= vec2(0.5);
	uv = rotate2d(-degrees * PI / 180.0) * uv;
	uv += vec2(0.5);
}

const vec2 CENTER = vec2(0.5);

void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);
	vec3 color = vec3(0.0);

	// Grey plus
	rotate(uv, 45.0);
	float plus_shape = plus(uv, vec2(inner_circle_thickness, white_circle_radius * 2.0));
	color = mix(color, color_a, plus_shape);
	reset_rotation(uv, 45.0);

	// Blue circles
	float circle0 = circle_outline(uv, blue_circle_radius_0, CENTER, inner_circle_thickness);
	float circle1 = circle_outline(uv, blue_circle_radius_1, CENTER, inner_circle_thickness);
	float circle2 = circle_outline(uv, blue_circle_radius_2, CENTER, inner_circle_thickness);
	float blue_circles = max(circle0, max(circle1, circle2));
	color = mix(color, color_b, blue_circles);

	// White circle
	float white_circle = circle_outline(uv, white_circle_radius, CENTER, outer_circle_thickness);
	color = mix(color, vec3(1.0), white_circle);

	// Dashed circle
	float dashed_circle = dashed_circle_outline(uv, dashed_circle_radius, outer_circle_thickness);
	color = mix(color, color_b, dashed_circle);

	// Triangles
	// TOP
	rotate(uv, 180.0);
	float triangle1 = tri(uv, triangle_size, vec2(CENTER.x, 0.05 + triangle_movement * sin(TIME)));
	color = mix(color, color_c, triangle1);
	reset_rotation(uv, 180.0);

	// BOTTOM
	float triangle2 = tri(uv, triangle_size, vec2(CENTER.x, 0.05 + triangle_movement * sin(TIME)));
	color = mix(color, color_c, triangle2);

	// LEFT
	rotate(uv, 90.0);
	float triangle3 = tri(uv, triangle_size, vec2(CENTER.x, 0.05 + triangle_movement * sin(TIME)));
	color = mix(color, color_c, triangle3);
	reset_rotation(uv, 90.0);

	// RIGHT
	rotate(uv, 270.0);
	float triangle4 = tri(uv, triangle_size, vec2(CENTER.x, 0.05 + triangle_movement * sin(TIME)));
	color = mix(color, color_c, triangle4);
	reset_rotation(uv, 270.0);

	// Moving Line
	float angle = -TIME * moving_line_speed * PI;
	vec2 rotating_point = CENTER + (white_circle_radius - 0.005) * vec2(cos(angle), sin(angle));
	float line_base = line(uv, CENTER, rotating_point, moving_line_thickness);

	vec2 d = uv - CENTER;
	float dist = length(d);
	d = normalize(d);
	float theta0 = angle * 180.0 / PI;
	float theta = mod(180.0 * atan(d.y, d.x) / PI - theta0 + 360.0, 360.0);
	float gradient = clamp(1.0 - theta / 90.0, 0.0, 1.0);

	float gradient_mask = radial_smooth(dist, white_circle_radius);
	float moving_line = line_base + 0.5 * gradient * gradient_mask;
	color = mix(color, color_d, moving_line);

	// Partial circle outline
	float partial_circle = partial_circle_outline(uv, partial_circle_radius, inner_circle_thickness, 0.5 + 0.2 * cos(TIME));
	color = mix(color, color_d, partial_circle);

	ALBEDO = color;
}
