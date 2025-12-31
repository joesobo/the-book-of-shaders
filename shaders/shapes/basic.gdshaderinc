float rect(in vec2 uv, in vec2 size) {
	size = 0.25 - size * 0.25;
	vec2 rect_uv = smoothstep(size, size + size * vec2(0.002), uv * (1.0 - uv));

	return rect_uv.x * rect_uv.y;
}
