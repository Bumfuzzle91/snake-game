shader_type canvas_item;

uniform float blur: hint_range(0,10);

void fragment(){
	vec4 col = textureLod(NORMAL_TEXTURE, UV, blur);
	COLOR = col;
}