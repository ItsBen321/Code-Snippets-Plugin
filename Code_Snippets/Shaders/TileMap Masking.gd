shader_type canvas_item;

uniform sampler2D world_texture : source_color;

uniform vec2 world_texture_size = vec2(64.0, 64.0);

uniform vec2 world_texture_origin = vec2(0.0, 0.0); // move this in the Inspector or via code

uniform float alpha_scale : hint_range(0.0, 1.0, 0.01) = 1.0;

varying vec2 WorldSpace;

void vertex() {
	WorldSpace = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	float mask = texture(TEXTURE, UV).a;

	vec2 uv = (WorldSpace - world_texture_origin) / world_texture_size;

	uv = clamp(uv, vec2(0.0), vec2(1.0));

	vec4 img = texture(world_texture, uv);
	
	float final_alpha = img.a * mask * alpha_scale;
	COLOR = vec4(img.rgb /* * alpha_scale */, final_alpha);
}
