#include "res://shaders/math/epsilon.gdshaderinc"
#include "res://shaders/math/bezier_helpers.gdshaderinc"

// Quadratic Bezier with control point (a,b), guaranteed same entering/exiting slopes
float quadratic_bezier(float x, float a, float b) {
	a = max(0.0, min(1.0, a));
	b = max(0.0, min(1.0, b));
	if (a == 0.5) {
		a += EPSILON;
	}

	// Solve t from x (an inverse operation)
	float om2a = 1.0 - 2.0 * a;
	float t = (sqrt(a * a + om2a * x) - a) / om2a;
	float y = (1.0 - 2.0 * b) * (t * t) + (2.0 * b) * t;
	return y;
}

// Cubic Bezier with two control points (a,b) and (c,d), extremely flexible curve
float cubic_bezier(float x, float a, float b, float c, float d) {
	float y0a = 0.0; // initial y
	float x0a = 0.0; // initial x
	float y1a = b;   // 1st influence y
	float x1a = a;   // 1st influence x
	float y2a = d;   // 2nd influence y
	float x2a = c;   // 2nd influence x
	float y3a = 1.0; // final y
	float x3a = 1.0; // final x

	float A = x3a - 3.0 * x2a + 3.0 * x1a - x0a;
	float B = 3.0 * x2a - 6.0 * x1a + 3.0 * x0a;
	float C = 3.0 * x1a - 3.0 * x0a;
	float D = x0a;

	float F = y3a - 3.0 * y2a + 3.0 * y1a - y0a;
	float G = 3.0 * y2a - 6.0 * y1a + 3.0 * y0a;
	float H = 3.0 * y1a - 3.0 * y0a;
	float I = y0a;

	// Solve for t given x (using Newton-Raphson), then solve for y given t
	// Assume for the first guess that t = x
	float currentt = x;
	int nRefinementIterations = 5;
	for (int i = 0; i < nRefinementIterations; i++) {
		float currentx = x_from_t(currentt, A, B, C, D);
		float currentslope = slope_from_t(currentt, A, B, C);
		currentt -= (currentx - x) * currentslope;
		currentt = clamp(currentt, 0.0, 1.0);
	}

	float y = y_from_t(currentt, F, G, H, I);
	return y;
}

// Cubic Bezier that attempts to pass nearly through two given points (a,b) and (c,d)
float cubic_bezier_nearly_through_two_points(float x, float a, float b, float c, float d) {
	float min_param_a = 0.0 + EPSILON;
	float max_param_a = 1.0 - EPSILON;
	float min_param_b = 0.0 + EPSILON;
	float max_param_b = 1.0 - EPSILON;
	a = max(min_param_a, min(max_param_a, a));
	b = max(min_param_b, min(max_param_b, b));

	float x0 = 0.0;
	float y0 = 0.0;
	float x4 = a;
	float y4 = b;
	float x5 = c;
	float y5 = d;
	float x3 = 1.0;
	float y3 = 1.0;
	float x1, y1, x2, y2; // to be solved

	// Arbitrary but reasonable t-values for interior control points
	float t1 = 0.3;
	float t2 = 0.7;

	float B0t1 = B0(t1);
	float B1t1 = B1(t1);
	float B2t1 = B2(t1);
	float B3t1 = B3(t1);
	float B0t2 = B0(t2);
	float B1t2 = B1(t2);
	float B2t2 = B2(t2);
	float B3t2 = B3(t2);

	float ccx = x4 - x0 * B0t1 - x3 * B3t1;
	float ccy = y4 - y0 * B0t1 - y3 * B3t1;
	float ffx = x5 - x0 * B0t2 - x3 * B3t2;
	float ffy = y5 - y0 * B0t2 - y3 * B3t2;

	x2 = (ccx - (ffx * B1t1) / B1t2) / (B2t1 - (B1t1 * B2t2) / B1t2);
	y2 = (ccy - (ffy * B1t1) / B1t2) / (B2t1 - (B1t1 * B2t2) / B1t2);
	x1 = (ccx - x2 * B2t1) / B1t1;
	y1 = (ccy - y2 * B2t1) / B1t1;

	x1 = max(0.0 + EPSILON, min(1.0 - EPSILON, x1));
	x2 = max(0.0 + EPSILON, min(1.0 - EPSILON, x2));

	// Use cubic_bezier() to compute the final curve
	float y = cubic_bezier(x, x1, y1, x2, y2);
	y = max(0.0, min(1.0, y));
	return y;
}
