shader_type canvas_item;

uniform int width;
uniform vec2 uv_scale = vec2(1,1);
uniform vec2 uv_translate = vec2(0,0);

varying vec2 st;

void vertex(){
	//scale and offset the uvs
	st = UV * uv_scale + uv_translate;
}

void fragment(){
	ivec2 int_tex_size = textureSize(TEXTURE, 0);
	vec2 tex_size = vec2(int_tex_size);
	
	//divide the uvs in x by the ratio of the scale texture size to snake width
	vec2 uv2 = st;
	uv2.x /= tex_size.x / float(width);

	vec4 tex = texture(TEXTURE, uv2);
	COLOR = tex;
}