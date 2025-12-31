float rect(in vec2 uv, in vec2 size) {
	size = 0.25 - size * 0.25;
	vec2 rect_uv = smoothstep(size, size + size * vec2(0.002), uv * (1.0 - uv));

	return rect_uv.x * rect_uv.y;
}

float tri(vec2 uv, float size) {
	uv -= 0.5;
	uv *= 5.0;
	float tri_sdf = max(abs(uv.x) * 0.866025 + uv.y * 0.5, -uv.y * 0.5);

	return step(size, tri_sdf);
}
