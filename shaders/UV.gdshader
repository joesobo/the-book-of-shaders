shader_type spatial;

void fragment() {
	// Invert the y UV coordinate to match traditional UV mapping
	ALBEDO = vec3(UV.x, 1.0 - UV.y, 0.0);
}
