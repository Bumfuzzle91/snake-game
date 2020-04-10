shader_type canvas_item;

uniform float smoothness: hint_range(0,5);

void fragment(){
	
	vec3 normals = textureLod(NORMAL_TEXTURE, UV, 1).xyz;
	vec3 smoothed_normals = textureLod(NORMAL_TEXTURE, UV, smoothness).xyz;
	
	vec3 output_normals = max(normals, smoothed_normals);
	
	NORMAL = output_normals;
	
	vec4 col = vec4(output_normals, 1);
	//vec4 col = vec4(.5,.5,.5,1);
	COLOR = col;
}