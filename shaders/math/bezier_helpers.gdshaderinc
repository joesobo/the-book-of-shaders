// Cubic Bezier helpers - solve for t and compute x/y values
float slope_from_t(float t, float A, float B, float C) {
	float dtdx = 1.0 / (3.0 * A * t * t + 2.0 * B * t + C);
	return dtdx;
}

float x_from_t(float t, float A, float B, float C, float D) {
	float x = A * (t * t * t) + B * (t * t) + C * t + D;
	return x;
}

float y_from_t(float t, float F, float G, float H, float I) {
	float y = F * (t * t * t) + G * (t * t) + H * t + I;
	return y;
}

// Bernstein basis functions for cubic Bezier
float B0(float t) {
	return (1.0 - t) * (1.0 - t) * (1.0 - t);
}

float B1(float t) {
	return 3.0 * t * (1.0 - t) * (1.0 - t);
}

float B2(float t) {
	return 3.0 * t * t * (1.0 - t);
}

float B3(float t) {
	return t * t * t;
}

float find_x(float t, float x0, float x1, float x2, float x3) {
	return x0 * B0(t) + x1 * B1(t) + x2 * B2(t) + x3 * B3(t);
}

float find_y(float t, float y0, float y1, float y2, float y3) {
	return y0 * B0(t) + y1 * B1(t) + y2 * B2(t) + y3 * B3(t);
}
