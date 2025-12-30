#include "res://shaders/math/epsilon.gdshaderinc"

// ============================================================================
// UTILITY HELPER FUNCTIONS
// ============================================================================

// Return signed distance from line Ax + By + C = 0 to point P
float line_to_point(float a, float b, float c, float ptx, float pty) {
	float lp = 0.0;
	float d = sqrt((a * a) + (b * b));
	if (d != 0.0) {
		lp = (a * ptx + b * pty + c) / d;
	}
	return lp;
}

// Check if given points are perpendicular to x or y axis
bool is_perpendicular(float pt1x, float pt1y, float pt2x, float pt2y, float pt3x, float pt3y) {
	float yDelta_a = pt2y - pt1y;
	float xDelta_a = pt2x - pt1x;
	float yDelta_b = pt3y - pt2y;
	float xDelta_b = pt3x - pt2x;

	if (abs(xDelta_a) <= EPSILON && abs(yDelta_b) <= EPSILON) {
		return false;
	}
	if (abs(yDelta_a) <= EPSILON) {
		return true;
	} else if (abs(yDelta_b) <= EPSILON) {
		return true;
	} else if (abs(xDelta_a) <= EPSILON) {
		return true;
	} else if (abs(xDelta_b) <= EPSILON) {
		return true;
	} else {
		return false;
	}
}

// Calculate circle from 3 points
void calc_circle_from_3_points(
	float pt1x, float pt1y,
	float pt2x, float pt2y,
	float pt3x, float pt3y,
	out float centerX, out float centerY, out float out_radius
) {
	float yDelta_a = pt2y - pt1y;
	float xDelta_a = pt2x - pt1x;
	float yDelta_b = pt3y - pt2y;
	float xDelta_b = pt3x - pt2x;

	if (abs(xDelta_a) <= EPSILON && abs(yDelta_b) <= EPSILON) {
		centerX = 0.5 * (pt2x + pt3x);
		centerY = 0.5 * (pt1y + pt2y);
		out_radius = sqrt((centerX - pt1x) * (centerX - pt1x) + (centerY - pt1y) * (centerY - pt1y));
		return;
	}

	float aSlope = yDelta_a / xDelta_a;
	float bSlope = yDelta_b / xDelta_b;
	if (abs(aSlope - bSlope) <= EPSILON) {
		out_radius = 0.0;
		return;
	}

	centerX = (
		aSlope * bSlope * (pt1y - pt3y) +
		bSlope * (pt1x + pt2x) -
		aSlope * (pt2x + pt3x)
	) / (2.0 * (bSlope - aSlope));
	centerY = -1.0 * (centerX - (pt1x + pt2x) / 2.0) / aSlope + (pt1y + pt2y) / 2.0;
	out_radius = sqrt((centerX - pt1x) * (centerX - pt1x) + (centerY - pt1y) * (centerY - pt1y));
}

// Compute parameters of circular arc fillet between two lines with radius R
void compute_fillet_parameters(
	float p1x, float p1y,
	float p2x, float p2y,
	float p3x, float p3y,
	float p4x, float p4y,
	float r,
	out float arcCenterX, out float arcCenterY,
	out float arcStartX, out float arcStartY,
	out float arcEndX, out float arcEndY,
	out float arcRadius
) {
	float c1 = p2x * p1y - p1x * p2y;
	float a1 = p2y - p1y;
	float b1 = p1x - p2x;
	float c2 = p4x * p3y - p3x * p4y;
	float a2 = p4y - p3y;
	float b2 = p3x - p4x;

	if ((a1 * b2) == (a2 * b1)) {
		arcRadius = 0.0;
		return;
	}

	float mPx = (p3x + p4x) / 2.0;
	float mPy = (p3y + p4y) / 2.0;
	float d1 = line_to_point(a1, b1, c1, mPx, mPy);
	if (d1 == 0.0) {
		arcRadius = 0.0;
		return;
	}

	mPx = (p1x + p2x) / 2.0;
	mPy = (p1y + p2y) / 2.0;
	float d2 = line_to_point(a2, b2, c2, mPx, mPy);
	if (d2 == 0.0) {
		arcRadius = 0.0;
		return;
	}

	float rr = r;
	if (d1 <= 0.0) {
		rr = -rr;
	}
	float c1p = c1 - rr * sqrt((a1 * a1) + (b1 * b1));

	rr = r;
	if (d2 <= 0.0) {
		rr = -rr;
	}
	float c2p = c2 - rr * sqrt((a2 * a2) + (b2 * b2));
	float d = (a1 * b2) - (a2 * b1);

	float pCx = (c2p * b1 - c1p * b2) / d;
	float pCy = (c1p * a2 - c2p * a1) / d;

	float dP = (a1 * a1) + (b1 * b1);
	float pAx = 0.0;
	float pAy = 0.0;
	if (dP != 0.0) {
		float cP = a1 * pCy - b1 * pCx;
		pAx = (-a1 * c1 - b1 * cP) / dP;
		pAy = (a1 * cP - b1 * c1) / dP;
	}

	dP = (a2 * a2) + (b2 * b2);
	float pBx = 0.0;
	float pBy = 0.0;
	if (dP != 0.0) {
		float cP = a2 * pCy - b2 * pCx;
		pBx = (-a2 * c2 - b2 * cP) / dP;
		pBy = (a2 * cP - b2 * c2) / dP;
	}

	float gv1x = pAx - pCx;
	float gv1y = pAy - pCy;
	float gv2x = pBx - pCx;
	float gv2y = pBy - pCy;

	float arcStart = atan(gv1y, gv1x);
	float arcAngle = 0.0;
	float dd = sqrt(((gv1x * gv1x) + (gv1y * gv1y)) * ((gv2x * gv2x) + (gv2y * gv2y)));
	if (dd != 0.0) {
		arcAngle = acos((gv1x * gv2x + gv1y * gv2y) / dd);
	}

	float crossProduct = (gv1x * gv2y - gv2x * gv1y);
	if (crossProduct < 0.0) {
		arcStart -= arcAngle;
	}

	float arc1 = arcStart;
	float arc2 = arcStart + arcAngle;
	if (crossProduct < 0.0) {
		arc1 = arcStart + arcAngle;
		arc2 = arcStart;
	}

	arcCenterX = pCx;
	arcCenterY = pCy;
	arcRadius = r;
	arcStartX = arcCenterX + arcRadius * cos(arc1);
	arcStartY = arcCenterY + arcRadius * sin(arc1);
	arcEndX = arcCenterX + arcRadius * cos(arc2);
	arcEndY = arcCenterY + arcRadius * sin(arc2);
}
