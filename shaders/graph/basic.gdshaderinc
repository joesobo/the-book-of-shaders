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
vec3 draw_dot(vec3 color, vec2 uv, vec2 position, vec3 dot_color, float dot_radius) {
	float dot_edge = 0.003;
	float dist = distance(uv, position);
	float dot_mask = 1.0 - smoothstep(dot_radius - dot_edge, dot_radius + dot_edge, dist);
	return mix(color, dot_color, dot_mask);
}
