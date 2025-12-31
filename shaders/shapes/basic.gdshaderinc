// Smooth filled rectangle (centered at 0.5, 0.5)
float rect(in vec2 uv, in vec2 size) {
	size = 0.25 - size * 0.25;
	vec2 rect_uv = smoothstep(size, size + size * vec2(0.002), uv * (1.0 - uv));

	return rect_uv.x * rect_uv.y;
}

// Hard-edged filled rectangle with margin from edges
float rect(vec2 uv, float margin) {
	vec2 bl = step(vec2(margin), uv);
	vec2 tr = step(vec2(margin), 1.0 - uv);
	return bl.x * bl.y * tr.x * tr.y;
}

// Hard-edged filled rectangle at specific position
float rect(vec2 uv, vec2 center, vec2 size) {
	vec2 p = (uv - center) / size;
	vec2 bl = step(vec2(-0.5), p);
	vec2 tr = step(p, vec2(0.5));
	return bl.x * bl.y * tr.x * tr.y;
}

// Rectangle outline at specific position
float rect_outline(vec2 uv, vec2 center, vec2 size, float line_width) {
	vec2 p = (uv - center) / size;

	// Outer rectangle: check if within bounds [-0.5, 0.5]
	vec2 outer_bl = step(vec2(-0.5), p);
	vec2 outer_tr = step(p, vec2(0.5));
	float outer = outer_bl.x * outer_bl.y * outer_tr.x * outer_tr.y;

	// Inner rectangle: subtract line_width from all sides (normalized by size)
	vec2 inner_margin = vec2(line_width) / size;
	vec2 inner_bl = step(vec2(-0.5) + inner_margin, p);
	vec2 inner_tr = step(p, vec2(0.5) - inner_margin);
	float inner = inner_bl.x * inner_bl.y * inner_tr.x * inner_tr.y;

	return outer - inner;
}

float tri(vec2 uv, float size) {
	uv -= 0.5;
	uv *= 5.0;
	float tri_sdf = max(abs(uv.x) * 0.866025 + uv.y * 0.5, -uv.y * 0.5);

	return step(size, tri_sdf);
}
