// Heartbeat pattern components:
// - Quick spike (QRS complex) around 0.2-0.3
// - Small dip (P wave) around 0.4
// - Plateau/bump (T wave) around 0.5-0.6
// - Baseline for rest
float heartbeat(float x) {
	float cycle = mod(x, 1.0);
	float y = 0.0;

	// Baseline
	if (cycle < 0.15 || cycle > 0.7) {
		y = 0.1;
	}
	// QRS complex - quick spike
	else if (cycle >= 0.15 && cycle < 0.35) {
		float t = (cycle - 0.15) / 0.2;
		y = 0.1 + 0.9 * exp(-20.0 * (t - 0.5) * (t - 0.5));
	}
	// Small dip (P wave)
	else if (cycle >= 0.35 && cycle < 0.45) {
		y = 0.1;
	}
	// T wave plateau
	else if (cycle >= 0.45 && cycle < 0.7) {
		float t = (cycle - 0.45) / 0.25;
		y = 0.1 + 0.9 * exp(-20.0 * (t - 0.5) * (t - 0.5));
	}

	return clamp(y, 0.0, 1.0);
}
