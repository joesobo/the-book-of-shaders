shader_type spatial;

uniform float scale : hint_range(0.0, 1.0) = 0.5;
uniform float offset : hint_range(0.0, 1.0) = 0.5;
uniform float a_value : hint_range(0.0, 1.0) = 0.5;
uniform float b_value : hint_range(0.0, 1.0) = 0.5;
uniform int n_value : hint_range(1, 20) = 1;
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
	"Logistic Sigmoid"
) = 21;

#include "res://shaders/math/epsilon.gdshaderinc"
#include "res://shaders/math/polynomial.gdshaderinc"
#include "res://shaders/math/exponential.gdshaderinc"

// Plot line on Y using value between 0 and 1
float plot(vec2 st, float pct) {
	return smoothstep(pct - 0.02, pct, st.y) - smoothstep(pct, pct + 0.02, st.y);
}

void fragment() {
	vec2 st = vec2(UV.x, 1.0 - UV.y);
	float x = sin(TIME + st.x * PI);

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
			y = riased_inverted_cosine(st.x);
			break;
		case 13:
			y = double_cubic_seats(st.x, a_value, b_value);
			break;
		case 14:
			y = double_cubic_seats_with_linear_blend(st.x, a_value, b_value);
			break;
		case 15:
			y = double_odd_polynomial_seats(st.x, a_value, b_value, n_value);
			break;
		case 16:
			y = double_polynomial_sigmoid(st.x, n_value);
			break;
		case 17:
			y = quadratic_through_point(st.x, a_value, b_value);
			break;
		case 18:
			y = exponential_easing(st.x, a_value);
			break;
		case 19:
			y = double_exponential_seat(st.x, a_value);
			break;
		case 20:
			y = double_exponential_sigmoid(st.x, a_value);
			break;
		case 21:
			y = logistic_sigmoid(st.x, a_value);
			break;
	}

	y *= scale;
	y += offset;
	vec3 color = vec3(y);

	float pct = plot(st, y);
	color = (1.0 - pct) * color + pct * vec3(0.0, 1.0, 0.0);

	ALBEDO = color;
}
