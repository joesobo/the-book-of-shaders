#include "res://shaders/math/custom.gdshaderinc"

// Smooth filled rectangle (centered at 0.5, 0.5)
float rect(in vec2 uv, in vec2 size) {
	size = 0.25 - size * 0.25;
	vec2 rect_uv = smoothstep(size, size + size * vec2(0.002), uv * (1.0 - uv));

	return rect_uv.x * rect_uv.y;
}

float box(in vec2 uv, in vec2 size) {
	size = 0.5 - size * 0.5;
	vec2 rect_uv = smoothstep(size, size + vec2(0.001), uv);
	rect_uv *= smoothstep(size, size + vec2(0.001), vec2(1.0) - uv);

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

float plus(vec2 uv, float size) {
	return max(box(uv, vec2(size, size / 4.0)), box(uv, vec2(size / 4.0, size)));
}

float plus(vec2 uv, vec2 size) {
	return max(box(uv, vec2(size.x, size.y)), box(uv, vec2(size.y, size.x)));
}

float tri(vec2 uv, float size, vec2 center) {
	uv -= center;
	uv *= 5.0;
	float tri_sdf = max(abs(uv.x) * 0.866025 + uv.y * 0.5, -uv.y * 0.5);

	return 1.0 - step(size, tri_sdf);
}

float tri(vec2 uv, float size) {
	return tri(uv, size, vec2(0.5));
}

float circle(vec2 uv, float radius, vec2 center) {
	vec2 dist = uv - center;

	return smoothstep(radius - (radius * 0.01), radius + (radius * 0.01), dot(dist, dist) * 4.0);
}

float circle(vec2 uv, float radius) {
	return circle(uv, radius, vec2(0.5));
}

float circle_blur(vec2 uv, float radius, vec2 center) {
	return distance(uv, center) / radius;
}

float circle_blur(vec2 uv, float radius) {
	return circle_blur(uv, radius, vec2(0.5));
}

float circle_outline(vec2 uv, float radius, vec2 center, float line_width) {
	float dist = distance(uv, center);

	// Create outer edge at radius + line_width/2
	float outer = smoothstep(radius + line_width / 2.0 - 0.001, radius + line_width / 2.0, dist);

	// Create inner edge at radius - line_width/2
	float inner = smoothstep(radius - line_width / 2.0, radius - line_width / 2.0 + 0.001, dist);

	// Outline is the area between inner and outer edges (inside outer, outside inner)
	return inner * (1.0 - outer);
}

float circle_outline(vec2 uv, float radius) {
	return circle_outline(uv, radius, vec2(0.5), 0.01);
}

// Dashed circle outline with repeating angular pattern
float dashed_circle_outline(vec2 uv, vec2 center, float radius, float width) {
	vec2 d = uv - center;
	float r = sqrt(dot(d, d));
	d = normalize(d);
	float theta = 180.0 * (atan(d.y, d.x) / PI);

	// Create 45-degree repeating dash pattern
	float dash_pattern = smoothstep(2.0, 2.1, abs(mod(theta + 2.0, 45.0) - 2.0));

	// Alternate intensity every 45 degrees
	float intensity = mix(0.5, 1.0, step(45.0, abs(mod(theta, 180.0) - 90.0)));

	// Create ring outline
	float inner = smoothstep(radius - width / 2.0, radius, r);
	float outer = smoothstep(radius, radius + width / 2.0, r);
	float ring = inner * (1.0 - outer);

	return dash_pattern * intensity * ring;
}

float dashed_circle_outline(vec2 uv, float radius, float width) {
	return dashed_circle_outline(uv, vec2(0.5), radius, width);
}

// Partial circle outline with horizontal opening
float partial_circle_outline(vec2 uv, vec2 center, float radius, float width, float opening) {
	vec2 d = uv - center;
	float r = sqrt(dot(d, d));
	d = normalize(d);
	if (abs(d.y) > opening) {
		// Create outer edge at radius + width/2
		float outer = smoothstep(radius + width / 2.0 - 0.001, radius + width / 2.0, r);

		// Create inner edge at radius - width/2
		float inner = smoothstep(radius - width / 2.0, radius - width / 2.0 + 0.001, r);

		// Outline is the area between inner and outer edges (inside outer, outside inner)
		return inner * (1.0 - outer);
	} else {
		return 0.0;
	}
}

float partial_circle_outline(vec2 uv, float radius, float width, float opening) {
	return partial_circle_outline(uv, vec2(0.5), radius, width, opening);
}

// Draw a line segment from p1 to p2 with specified thickness
float line(vec2 uv, vec2 p1, vec2 p2, float thickness) {
	vec2 pa = uv - p1;
	vec2 ba = p2 - p1;
	float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
	float dist = length(pa - ba * h);

	return 1.0 - smoothstep(thickness - 0.001, thickness + 0.001, dist);
}

// Draw a line segment with default thickness
float line(vec2 uv, vec2 p1, vec2 p2) {
	return line(uv, p1, p2, 0.01);
}
