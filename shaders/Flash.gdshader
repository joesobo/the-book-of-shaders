shader_type spatial;

uniform float flash_speed : hint_range(0.0, 10.0) = 1.0;

void fragment() {
	ALBEDO = vec3(abs(sin(TIME * flash_speed)), cos(TIME * flash_speed), sin(TIME * flash_speed));
}
