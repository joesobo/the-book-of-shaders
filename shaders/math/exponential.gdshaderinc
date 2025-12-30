#include "res://shaders/math/epsilon.gdshaderinc"

// Parameter 'a' varies the function from ease-out (a < 0.5) to ease-in (a > 0.5)
float exponential_easing(float x, float a) {
	float min_param_a = 0.0 + EPSILON;
	float max_param_a = 1.0 - EPSILON;
	a = min(max_param_a, max(min_param_a, a));

	if (a < 0.5) {
		a *= 2.0;
		float y = pow(x, a);
		return y;
	} else {
		a = 2.0 * (a - 0.5);
		float y = pow(x, 1.0 / (1.0 - a));
		return y;
	}
}

// Seat-shaped function with nicer derivatives than cubic and more continuous control
float double_exponential_seat(float x, float a) {
	float min_param_a = 0.0 + EPSILON;
	float max_param_a = 1.0 - EPSILON;
	a = min(max_param_a, max(min_param_a, a));

	float y = 0.0;
	if (x < 0.5) {
		y = (pow(2.0 * x, 1.0 - a)) / 2.0;
	} else {
		y = 1.0 - (pow(2.0 * (1.0 - x), 1.0 - a)) / 2.0;
	}

	return y;
}

// Adjustable-contrast sigmoid from paired exponentials, approximates raised inverted cosine when a ≈ 0.426
float double_exponential_sigmoid(float x, float a) {
	float min_param_a = 0.0 + EPSILON;
	float max_param_a = 1.0 - EPSILON;
	a = min(max_param_a, max(min_param_a, a));
	a = 1.0 - a;

	float y = 0.0;
	if (x < 0.5) {
		y = (pow(2.0 * x, 1.0 / a)) / 2.0;
	} else {
		y = 1.0 - (pow(2.0 * (1.0 - x), 1.0 / a)) / 2.0;
	}

	return y;
}

// Natural sigmoid representing organic growth, parameter 'a' regulates slope during rising portion
float logistic_sigmoid(float x, float a) {
	float min_param_a = 0.0 + EPSILON;
	float max_param_a = 1.0 - EPSILON;
	a = min(max_param_a, max(min_param_a, a));
	a = (1.0 / (1.0 - a) - 1.0);

	float A = 1.0 / (1.0 + exp(0.0 - ((x - 0.5) * a * 2.0)));
	float B = 1.0 / (1.0 + exp(a));
	float C = 1.0 / (1.0 + exp(0.0 - a));
	float y = (A - B) / (C - B);

	return y;
}
