#snake_body.gd
extends Polygon2D

export(int) var width = 64
export(int) var length = 512
export(int) var resolution = 60

export(Texture) var scale_texture
export(CurveTexture) var distort_curve_texture

var path
var follow
var curve
var distort_curve

#onready var head = get_parent()
var head

var rid
var tex

var verts
var uvs

func _enter_tree():
	head = get_parent()

func _ready():
	path = $SnakePath
	follow = path.get_child(0)
	curve = path.curve
	distort_curve = distort_curve_texture.curve
	
	#initializations for drawing with visual server
	rid = get_canvas_item()
	tex = scale_texture.get_rid()
	
	create_mesh_from_path()
	update()

func _process(delta):
	create_mesh_from_path()
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

	indices = PoolIntArray(indices)

	#move the transform to align with the head
	draw_set_transform(Vector2(-to_global(position)), rotation, scale)

	VisualServer.canvas_item_add_triangle_array(rid, indices, verts, PoolColorArray(), uvs,
			PoolIntArray(), PoolRealArray(), tex)

func create_mesh_from_path():
	verts = []
	uvs = []

	var points = curve.get_baked_points()
	var segments = points.size()

	var point_offset = Vector2(width, width) * .5
	follow.v_offset = width

	#reverse the curve so that it is drawn (from our perspective) back to front
	#otherwise the snake would appear to go under itself when overlapping itself
	points.invert()

	for i in range(0, segments):
		var point = points[i]
		var follow_offset = curve.get_closest_offset(point)
		var normal = (follow.position - point).normalized()

		#path follow offset in pixels
		follow.offset = follow_offset

		#multiply offset by distortion curve. values for interpolate expected to be normalized
		var new_point_offset = point_offset * distort_curve.interpolate(follow_offset / curve.get_baked_length())

		verts.append(point - new_point_offset * normal)
		verts.append(point + new_point_offset * normal)

		uvs.append(Vector2(0, i / (segments - 1.0)))
		uvs.append(Vector2(1, i / (segments - 1.0)))

	verts = PoolVector2Array(verts)
	uvs = PoolVector2Array(uvs)

