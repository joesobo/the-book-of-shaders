shader_type spatial;

uniform float scale : hint_range(0.0, 1.0) = 0.5;
uniform float offset : hint_range(0.0, 1.0) = 0.5;
uniform float a_value : hint_range(0.0, 1.0) = 0.5;
uniform float b_value : hint_range(0.0, 1.0) = 0.5;
uniform float c_value : hint_range(0.0, 1.0) = 0.5;
uniform float d_value : hint_range(0.0, 1.0) = 0.5;
uniform int n_value : hint_range(1, 20) = 1;
uniform float radius : hint_range(0.0, 1.0) = 0.3;
uniform float dot_radius : hint_range(0.001, 0.05) = 0.015;
uniform int function_type : hint_enum(
	"Ceil + Floor",
	"Fract",
	"Mod",
	"Ceil",
	"Floor",
	"Sign",
	"Abs",
	"Clamp",
	"Min",
	"Max",
	"Atan",
	"Sin",
	"Raised Inverted Cosine",
	"Double Cubic Seats",
	"Double Cubic Seats (Linear Blend)",
	"Double Odd Polynomial Seats",
	"Double Polynomial Sigmoid",
	"Quadratic Through Point",
	"Exponential Easing",
	"Double Exponential Seat",
	"Double Exponential Sigmoid",
	"Logistic Sigmoid",
	"Circular Ease In",
	"Circular Ease Out",
	"Double Circle Seat",
	"Double Circle Sigmoid",
	"Double Elliptic Seat",
	"Double Elliptic Sigmoid",
	"Circular Fillet",
	"Circular Arc Through Point",
	"Quadratic Bezier",
	"Cubic Bezier",
	"Cubic Bezier Nearly Through Two Points"
) = 32;

#include "res://shaders/math/polynomial.gdshaderinc"
#include "res://shaders/math/exponential.gdshaderinc"
#include "res://shaders/math/circular.gdshaderinc"
#include "res://shaders/math/bezier.gdshaderinc"

// Plot line on Y using value between 0 and 1
float plot(vec2 uv, float pct) {
	return smoothstep(pct - 0.02, pct, uv.y) - smoothstep(pct, pct + 0.02, uv.y);
}

// Draw a grey line between two points
vec3 draw_line(vec3 color, vec2 uv, vec2 p1, vec2 p2) {
	float line_width = 0.004;
	float line_edge = 0.001;
	vec3 grey = vec3(0.5, 0.5, 0.5);

	// Calculate distance from point to line segment
	vec2 pa = uv - p1;
	vec2 ba = p2 - p1;
	float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
	float dist = length(pa - ba * h);

	float line_mask = 1.0 - smoothstep(line_width - line_edge, line_width + line_edge, dist);
	return mix(color, grey, line_mask);
}

// Draw a dot at a given position with a given color
vec3 draw_dot(vec3 color, vec2 uv, vec2 position, vec3 dot_color) {
	float dot_edge = 0.003;
	float dist = distance(uv, position);
	float dot_mask = 1.0 - smoothstep(dot_radius - dot_edge, dot_radius + dot_edge, dist);
	return mix(color, dot_color, dot_mask);
}

void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);
	float x = sin(TIME + uv.x * PI);

	float y;
	switch (function_type) {
		case 0:
			y = ceil(x) + floor(x);
			break;
		case 1:
			y = fract(x);
			break;
		case 2:
			y = mod(x, 0.5);
			break;
		case 3:
			y = ceil(x);
			break;
		case 4:
			y = floor(x);
			break;
		case 5:
		default:
			y = sign(x);
			break;
		case 6:
			y = abs(x);
			break;
		case 7:
			y = clamp(x, 0.0, 1.0);
			break;
		case 8:
			y = min(0.0, x);
			break;
		case 9:
			y = max(0.0, x);
			break;
		case 10:
			y = atan(x);
			break;
		case 11:
			y = sin(x);
			break;
		case 12:
			y = riased_inverted_cosine(uv.x);
			break;
		case 13:
			y = double_cubic_seats(uv.x, a_value, b_value);
			break;
		case 14:
			y = double_cubic_seats_with_linear_blend(uv.x, a_value, b_value);
			break;
		case 15:
			y = double_odd_polynomial_seats(uv.x, a_value, b_value, n_value);
			break;
		case 16:
			y = double_polynomial_sigmoid(uv.x, n_value);
			break;
		case 17:
			y = quadratic_through_point(uv.x, a_value, b_value);
			break;
		case 18:
			y = exponential_easing(uv.x, a_value);
			break;
		case 19:
			y = double_exponential_seat(uv.x, a_value);
			break;
		case 20:
			y = double_exponential_sigmoid(uv.x, a_value);
			break;
		case 21:
			y = logistic_sigmoid(uv.x, a_value);
			break;
		case 22:
			y = circular_ease_in(uv.x);
			break;
		case 23:
			y = circular_ease_out(uv.x);
			break;
		case 24:
			y = double_circle_seat(uv.x, a_value);
			break;
		case 25:
			y = double_circle_sigmoid(uv.x, a_value);
			break;
		case 26:
			y = double_elliptic_seat(uv.x, a_value, b_value);
			break;
		case 27:
			y = double_elliptic_sigmoid(uv.x, a_value, b_value);
			break;
		case 28:
			y = circular_fillet(uv.x, a_value, b_value, radius);
			break;
		case 29:
			y = circular_arc_through_point(uv.x, a_value, b_value);
			break;
		case 30:
			y = quadratic_bezier(uv.x, a_value, b_value);
			break;
		case 31:
			y = cubic_bezier(uv.x, a_value, b_value, c_value, d_value);
			break;
		case 32:
			y = cubic_bezier_nearly_through_two_points(uv.x, a_value, b_value, c_value, d_value);
			break;
	}

	y *= scale;
	y += offset;
	vec3 color = vec3(y);

	float pct = plot(uv, y);
	color = (1.0 - pct) * color + pct * vec3(0.0, 1.0, 0.0);

	// Draw control point markers for functions that use them
	switch (function_type) {
		case 13: // Double Cubic Seats
		case 14: // Double Cubic Seats (Linear Blend)
		case 15: // Double Odd Polynomial Seats
		case 17: // Quadratic Through Point
		case 28: // Circular Fillet
		case 29: // Circular Arc Through Point
		case 30: // Quadratic Bezier
			color = draw_line(color, uv, vec2(0.0, 0.0), vec2(a_value, b_value));
			color = draw_dot(color, uv, vec2(a_value, b_value), vec3(1.0, 0.0, 0.0));
			color = draw_line(color, uv, vec2(a_value, b_value), vec2(1.0, 1.0));
			break;
		case 31: // Cubic Bezier
		case 32: // Cubic Bezier Nearly Through Two Points
			color = draw_line(color, uv, vec2(0.0, 0.0), vec2(a_value, b_value));
			color = draw_dot(color, uv, vec2(a_value, b_value), vec3(1.0, 0.0, 0.0));
			color = draw_line(color, uv, vec2(a_value, b_value), vec2(c_value, d_value));
			color = draw_dot(color, uv, vec2(c_value, d_value), vec3(0.0, 0.0, 1.0));
			color = draw_line(color, uv, vec2(c_value, d_value), vec2(1.0, 1.0));
			break;
	}

	ALBEDO = color;
}
