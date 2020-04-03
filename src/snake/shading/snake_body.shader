shader_type canvas_item;

uniform int width;
uniform float scale_with_length : hint_range(0,1) = 1;
uniform vec2 uv_scale = vec2(1,1);
uniform vec2 uv_translate = vec2(0,0);

varying vec2 st;

void vertex(){
	
	//scale the uvs along the bodys length by a factor of scale_with_length
	//at 0, no scaling is done - scale size appears to shrink as body gets thinner
	//at UV's are stretched to counteract the distortion - scales appear uniform size throughout
	vec2 us = uv_scale;
	float offset = us.x;
	us.x -= offset * (1. - UV.y) * scale_with_length;
	
	//scale and offset the uvs
	st = UV * us + uv_translate;
}

void fragment(){
	ivec2 int_tex_size = textureSize(TEXTURE, 0);
	vec2 tex_size = vec2(int_tex_size);
	
	//divide the uvs in x by the ratio of the scale texture size to snake width
	//basically makes the texture "fit" to the body
	vec2 uv2 = st;
	uv2.x /= tex_size.x / float(width);
	
	//visualize UV's for debugging
	//vec4 uv2_tex = vec4(uv2, 0, 1);
	
	vec4 tex = texture(TEXTURE, uv2);
	COLOR = tex;
}