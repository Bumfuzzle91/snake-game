shader_type canvas_item;

uniform int width;

void fragment(){
	ivec2 int_tex_size = textureSize(TEXTURE, 0);
	vec2 tex_size = vec2(int_tex_size);
	
	vec2 uv_scale = vec2(tex_size.x / float(width), 1.);
	vec2 uv2 = vec2(UV / uv_scale);
	//texture variable works because it was assigned in visual server call
	vec4 tex = texture(TEXTURE, uv2);
	COLOR = tex;
}