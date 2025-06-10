shader_type canvas_item;

uniform vec4 outline_color : source_color;
uniform float line_thickness : hint_range(0, 20) = 1.0;    // thickness of the line

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
	
	vec4 sprite_color = texture(TEXTURE, UV);
	float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
	outline = min(outline, 1.0);

	// vec4 final_color = vec4(1.0, 0.0, 0.0, 1.0);
	COLOR = mix(sprite_color, outline_color, outline - sprite_color.a);
}

