shader_type spatial;
render_mode unshaded, skip_vertex_transform;

varying smooth vec3 object_space_vertex;

void vertex(){
	object_space_vertex = VERTEX;
	
	VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
    NORMAL = (MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;
}

void fragment(){
	
	float val = abs(object_space_vertex.z);
	vec3 albedo = vec3(val);
	
	ALBEDO = albedo;
}