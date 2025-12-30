#include "res://shaders/math/epsilon.gdshaderinc"

// Riased Inverted Cosine (Blinn-Wyvill)
// Useful approximation for the cos() and sin() trigonometric functions
float riased_inverted_cosine(float x) {
	float x2 = x * x;
	float x4 = x2 * x2;
	float x6 = x4 * x2;

	float fa = (4.0 / 9.0);
	float fb = (17.0 / 9.0);
	float fc = (22.0 / 9.0);

	float y = fa * x6 - fb * x4 + fc * x2;
	return y;
}

// The curves meet with a horizontal inflection point at the control coordinate (a,b)
float double_cubic_seats(float x, float a, float b) {
	float min_param_a = 0.0 + EPSILON;
	float max_param_a = 1.0 - EPSILON;
	float min_param_b = 0.0;
	float max_param_b = 1.0;

	a = min(max_param_a, max(min_param_a, a));
	b = min(max_param_b, max(min_param_b, b));

	float y = 0.0;
	if (x <= a) {
		y = b - b * pow(1.0 - x / a, 3.0);
	} else {
		y = b + (1.0 - b) * pow(x - a / (1.0 - a), 3.0);
	}
	return y;
}

// Uses a single variable to control the location of its inflection point along the diagonal of the unit square.
// A second parameter is used to blend this curve with the Identity Function (y=x).
// Here, we use the variable b to control the amount of this blend, which has the effect of tilting the slope of the curve's plateau in the vicinity of its inflection point.
// The adjustable flattening around the inflection point makes this a useful shaping function for lensing or magnifying evenly-spaced data.
float double_cubic_seats_with_linear_blend(float x, float a, float b) {
	float min_param_a = 0.0 + EPSILON;
	float max_param_a = 1.0 - EPSILON;
	float min_param_b = 0.0;
	float max_param_b = 1.0;

	a = min(max_param_a, max(min_param_a, a));
	b = min(max_param_b, max(min_param_b, b));
	b = 1.0 - b;

	float y = 0.0;
	if (x <= a) {
		y = b * x + (1.0 - b) * a * (1.0 - pow(1.0 - x / a, 3.0));
	} else {
		y = b * x + (1.0 - b) * (a + (1.0 - a) * pow((x - a) / (1.0 - a), 3.0));
	}
	return y;
}

// Parameter n controls the flatness or breadth of the plateau region in the vicinity of the point (a,b)
float double_odd_polynomial_seats(float x, float a, float b, int n) {
	float min_param_a = 0.0 + EPSILON;
	float max_param_a = 1.0 - EPSILON;
	float min_param_b = 0.0;
	float max_param_b = 1.0;

	a = min(max_param_a, max(min_param_a, a));
	b = min(max_param_b, max(min_param_b, b));

	float p = float(2 * n + 1);
	float y = 0.0;
	if (x <= a) {
		y = b - b * pow(1.0 - x / a, p);
	} else {
		y = b + (1.0 + b) * pow((x - a) / (1.0 - a), p);
	}
	return y;
}

// Creates an S-shape with flat tangents at 0 and 1
float double_polynomial_sigmoid(float x, int n) {
	float y = 0.0;
	if (n % 2 == 0) {
		// even polynomial
		if (x <= 0.5) {
			y = pow(2.0 * x, float(n)) / 2.0;
		} else {
			y = 1.0 - pow(2.0 * abs(x - 1.0), float(n)) / 2.0;
		}
	} else {
		// odd polynomial
		if (x <= 0.5) {
			y = pow(2.0 * x, float(n)) / 2.0;
		} else {
			y = 1.0 - pow(2.0 * abs(x - 1.0), float(n)) / 2.0;
		}
	}

	return y;
}

// Defines an axis-aligned quadratic (parabola) which passes through a user-supplied point (a,b) in the unit square
float quadratic_through_point(float x, float a, float b) {
	float min_param_a = 0.0 + EPSILON;
	float max_param_a = 1.0 - EPSILON;
	float min_param_b = 0.0;
	float max_param_b = 1.0;

	a = min(max_param_a, max(min_param_a, a));
	b = min(max_param_b, max(min_param_b, b));

	float A = (1.0 - b) / (1.0 - a) - (b / a);
	float B = (A * (a * a) - b) / a;
	float y = A * (x * x) - B * x;
	y = min(1.0, max(0.0, y));

	return y;
}
