#snake_path.gd
extends Path2D

var length = 0
var resolution = 0

var body

func _ready():
	body = get_parent()
	generate_path(body.length, body.resolution)
	
func _process(delta):
	follow_target(body.position)

func generate_path(_length, _resolution):
	curve.clear_points()
	
	length = _length
	resolution = _resolution

	#total number of points = resolution + 1
	for i in range(0, resolution + 1):
		var pos = Vector2(i * length/resolution, 0)
		
		curve.add_point(pos)
		
func follow_target(target_position):
	#curve positions in world space. makes it easier to work with them in body
	curve.set_point_position(0, to_global(target_position))
	for i in range(0, curve.get_point_count()-1):
		var p1 = curve.get_point_position(i)
		var p2 = curve.get_point_position(i+1)

		var vec = p1 - p2
		vec = vec.normalized() * length / resolution	
		curve.set_point_position(i+1, p1 - vec)

func _draw():
	#drawing transform is in local space, so we need to move to global so curve is in right spot
	
#	draw_set_transform(Vector2(-to_global(position)), rotation, scale)
#	draw_polyline(curve.get_baked_points(), Color.green, 20, true)
	pass
