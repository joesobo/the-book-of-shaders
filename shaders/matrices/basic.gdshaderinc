// Rotate around the origin (0, 0)
mat2 rotate2d(float angle) {
	return mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));
}

// Scale around the origin (0, 0)
mat2 scale(vec2 scale) {
	return mat2(vec2(scale.x, 0.0), vec2(0.0, scale.y));
}
