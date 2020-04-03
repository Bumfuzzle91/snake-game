#snake_pseudo_mesh.gd
extends Node2D

var body
export(NodePath) var path

var follow
var curve

var rid
var tex

var verts
var uvs
var path_normals
var path_offsets

func _ready():
	body = get_parent()
	
	path = get_node(path)
	follow = path.get_child(0)
	curve = path.curve
	
	rid = body.get_canvas_item()
	tex = body.scale_texture.get_rid()
	
	update_and_draw_mesh()
	
func _process(delta):
	update_and_draw_mesh()

func update_and_draw_mesh():
	assign_mesh_data_from_path()
	distort_mesh()
	update()

func _draw():
	var indices = []
	
	#dont forget the - 6
	var count = 0
	for i in range(0, (verts.size() * 3) - 6, 6):
		indices.append(count)
		indices.append(count + 1)
		indices.append(count + 2)

		indices.append(count + 2)
		indices.append(count + 1)
		indices.append(count + 3)

		count += 2

	#indices = PoolIntArray(indices)
	
	#regualr canvas item draw commands don't seem to work here
	#my theory is that because node2d doesn't draw, nothing is done automatically
	
	#draw_set_transform(Vector2(-to_global(position)), rotation, scale)
	var t = Transform2D(0, -to_global(position))
	
	#clear canvas and offset drawing transform to align with snake's head
	VisualServer.canvas_item_clear(rid)
	VisualServer.canvas_item_add_set_transform(rid, t)
#	
	VisualServer.canvas_item_add_triangle_array(rid, indices, verts, PoolColorArray(), uvs,
			PoolIntArray(), PoolRealArray(), tex)

func assign_mesh_data_from_path():
	verts = []
	uvs = []
	path_normals = []
	path_offsets = []
	
	var points = path.curve.get_baked_points()
	var segments = points.size()

	var point_offset = Vector2(body.width, body.width) * .5
	
	#reverse the curve so that it is drawn (from our perspective) back to front
	#otherwise the snake would appear to go under itself when overlapping itself
	points.invert()
	
	follow.v_offset = body.width
	for i in range(0, segments):
		var point = points[i]
		var follow_pixel_offset = curve.get_closest_offset(point)
		var path_offset = follow_pixel_offset / curve.get_baked_length()

		#path follow offset in pixels
		#must offset before getting normal, otherwise there are artifacts
		follow.offset = follow_pixel_offset
		var normal = (follow.position - point).normalized()

		verts.append(point + point_offset * -normal)
		verts.append(point + point_offset * normal)
		
		uvs.append(Vector2(0, i / (segments - 1.0)))
		uvs.append(Vector2(1, i / (segments - 1.0)))
		
		path_normals.append(-normal)
		path_normals.append(normal)
		
		path_offsets.append(path_offset)
		path_offsets.append(path_offset)
		
func distort_mesh():
	var distort_curve = body.distort_curve_texture.curve
	
	for i in range(0, verts.size()):
		var point = verts[i]
		
		var normal = path_normals[i]
		var offset = path_offsets[i]
		var distort_ammount = distort_curve.interpolate(offset)
		
		#distort ammount should be in -1 to 1 range: This means we can shrink and grow the body segments
		var new_point = point + body.width * .5 * normal * distort_ammount
		
		verts[i] = new_point
		
		

