shader_type spatial;
render_mode unshaded, skip_vertex_transform;

varying smooth vec3 model_normals;

void vertex(){
	model_normals = NORMAL;
	
	VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
    NORMAL = (MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;
}

void fragment(){
	vec3 albedo = vec3(model_normals * .5 + .5);
	
	ALBEDO = albedo;
}