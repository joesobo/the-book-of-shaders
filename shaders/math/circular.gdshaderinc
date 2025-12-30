#include "res://shaders/math/epsilon.gdshaderinc"
#include "res://shaders/math/utils.gdshaderinc"

// Quick circular arc easing in with square root for smooth deceleration
float circular_ease_in(float x) {
	float y = 1.0 - sqrt(1.0 - x * x);
	return y;
}

// Quick circular arc easing out with square root for smooth acceleration
float circular_ease_out(float x) {
	float y = sqrt(1.0 - (1.0 - x) * (1.0 - x));
	return y;
}

// Two circular arcs meeting with horizontal tangent, parameter 'a' controls inflection point location
float double_circle_seat(float x, float a) {
	float min_param_a = 0.0;
	float max_param_a = 1.0;
	a = max(min_param_a, min(max_param_a, a));

	float y = 0.0;
	if (x <= a) {
		y = sqrt(a * a - (x - a) * (x - a));
	} else {
		y = 1.0 - sqrt((1.0 - a) * (1.0 - a) - (x - a) * (x - a));
	}
	return y;
}

// Two circular arcs meeting with vertical tangent, parameter 'a' controls inflection point location
float double_circle_sigmoid(float x, float a) {
	float min_param_a = 0.0;
	float max_param_a = 1.0;
	a = max(min_param_a, min(max_param_a, a));

	float y = 0.0;
	if (x <= a) {
		y = a - sqrt(a * a - x * x);
	} else {
		y = a + sqrt((1.0 - a) * (1.0 - a) - (x - 1.0) * (x - 1.0));
	}
	return y;
}

// Two elliptical arcs meeting with horizontal tangent at (a,b), generalization of double circle seat
float double_elliptic_seat(float x, float a, float b) {
	float min_param_a = 0.0 + EPSILON;
	float max_param_a = 1.0 - EPSILON;
	float min_param_b = 0.0;
	float max_param_b = 1.0;
	a = max(min_param_a, min(max_param_a, a));
	b = max(min_param_b, min(max_param_b, b));

	float y = 0.0;
	if (x <= a) {
		y = (b / a) * sqrt(a * a - (x - a) * (x - a));
	} else {
		y = 1.0 - ((1.0 - b) / (1.0 - a)) * sqrt((1.0 - a) * (1.0 - a) - (x - a) * (x - a));
	}
	return y;
}

// Two elliptical arcs meeting with vertical tangent at (a,b), generalization of double circle sigmoid
float double_elliptic_sigmoid(float x, float a, float b) {
	float min_param_a = 0.0 + EPSILON;
	float max_param_a = 1.0 - EPSILON;
	float min_param_b = 0.0;
	float max_param_b = 1.0;
	a = max(min_param_a, min(max_param_a, a));
	b = max(min_param_b, min(max_param_b, b));

	float y = 0.0;
	if (x <= a) {
		y = b * (1.0 - (sqrt(a * a - x * x) / a));
	} else {
		y = b + ((1.0 - b) / (1.0 - a)) * sqrt((1.0 - a) * (1.0 - a) - (x - 1.0) * (x - 1.0));
	}
	return y;
}

// Joins two straight lines with circular arc fillet, adapted from Robert D. Miller / Graphics Gems III
float circular_fillet(float x, float a, float b, float R) {
	float min_param_a = 0.0 + EPSILON;
	float max_param_a = 1.0 - EPSILON;
	float min_param_b = 0.0 + EPSILON;
	float max_param_b = 1.0 - EPSILON;
	a = max(min_param_a, min(max_param_a, a));
	b = max(min_param_b, min(max_param_b, b));

	float arcCenterX, arcCenterY;
	float arcStartX, arcStartY;
	float arcEndX, arcEndY;
	float arcRadius;

	compute_fillet_parameters(
		0.0, 0.0, a, b, a, b, 1.0, 1.0, R,
		arcCenterX, arcCenterY,
		arcStartX, arcStartY,
		arcEndX, arcEndY,
		arcRadius
	);

	x = max(0.0, min(1.0, x));
	float y = 0.0;

	if (x <= arcStartX) {
		float t = x / arcStartX;
		y = t * arcStartY;
	} else if (x >= arcEndX) {
		float t = (x - arcEndX) / (1.0 - arcEndX);
		y = arcEndY + t * (1.0 - arcEndY);
	} else {
		if (x >= arcCenterX) {
			y = arcCenterY - sqrt(arcRadius * arcRadius - (x - arcCenterX) * (x - arcCenterX));
		} else {
			y = arcCenterY + sqrt(arcRadius * arcRadius - (x - arcCenterX) * (x - arcCenterX));
		}
	}
	return y;
}

// Circular arc passing through a given point (a,b), adapted from Paul Bourke
float circular_arc_through_point(float x, float a, float b) {
	float min_param_a = 0.0 + EPSILON;
	float max_param_a = 1.0 - EPSILON;
	float min_param_b = 0.0 + EPSILON;
	float max_param_b = 1.0 - EPSILON;
	a = min(max_param_a, max(min_param_a, a));
	b = min(max_param_b, max(min_param_b, b));
	x = min(1.0 - EPSILON, max(0.0 + EPSILON, x));

	float pt1x = 0.0;
	float pt1y = 0.0;
	float pt2x = a;
	float pt2y = b;
	float pt3x = 1.0;
	float pt3y = 1.0;

	float centerX, centerY, dRadius;

	if (!is_perpendicular(pt1x, pt1y, pt2x, pt2y, pt3x, pt3y)) {
		calc_circle_from_3_points(pt1x, pt1y, pt2x, pt2y, pt3x, pt3y, centerX, centerY, dRadius);
	} else if (!is_perpendicular(pt1x, pt1y, pt3x, pt3y, pt2x, pt2y)) {
		calc_circle_from_3_points(pt1x, pt1y, pt3x, pt3y, pt2x, pt2y, centerX, centerY, dRadius);
	} else if (!is_perpendicular(pt2x, pt2y, pt1x, pt1y, pt3x, pt3y)) {
		calc_circle_from_3_points(pt2x, pt2y, pt1x, pt1y, pt3x, pt3y, centerX, centerY, dRadius);
	} else if (!is_perpendicular(pt2x, pt2y, pt3x, pt3y, pt1x, pt1y)) {
		calc_circle_from_3_points(pt2x, pt2y, pt3x, pt3y, pt1x, pt1y, centerX, centerY, dRadius);
	} else if (!is_perpendicular(pt3x, pt3y, pt2x, pt2y, pt1x, pt1y)) {
		calc_circle_from_3_points(pt3x, pt3y, pt2x, pt2y, pt1x, pt1y, centerX, centerY, dRadius);
	} else if (!is_perpendicular(pt3x, pt3y, pt1x, pt1y, pt2x, pt2y)) {
		calc_circle_from_3_points(pt3x, pt3y, pt1x, pt1y, pt2x, pt2y, centerX, centerY, dRadius);
	} else {
		return 0.0;
	}

	// Constrain
	if ((centerX > 0.0) && (centerX < 1.0)) {
		if (a < centerX) {
			centerX = 1.0;
			centerY = 0.0;
			dRadius = 1.0;
		} else {
			centerX = 0.0;
			centerY = 1.0;
			dRadius = 1.0;
		}
	}

	float y = 0.0;
	if (x >= centerX) {
		y = centerY - sqrt(dRadius * dRadius - (x - centerX) * (x - centerX));
	} else {
		y = centerY + sqrt(dRadius * dRadius - (x - centerX) * (x - centerX));
	}
	return y;
}
