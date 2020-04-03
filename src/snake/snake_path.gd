#snake_path.gd
extends Path2D

var body

func _ready():
	body = get_parent()
	generate_path()
	
func _process(delta):
	follow_target(body.position)

func generate_path():
	curve.clear_points()

	#total number of points = resolution + 1
	for i in range(0, body.resolution + 1):
		var pos = Vector2(i * body.length / body.resolution, 0)
		
		curve.add_point(pos)
		
func follow_target(target_position):
	#curve positions in world space. makes it easier to work with them in body
	curve.set_point_position(0, to_global(target_position))
	for i in range(0, curve.get_point_count()-1):
		var p1 = curve.get_point_position(i)
		var p2 = curve.get_point_position(i+1)

		var vec = p1 - p2
		vec = vec.normalized() * body.length / body.resolution	
		curve.set_point_position(i+1, p1 - vec)

func _draw():
	#drawing transform is in local space, so we need to move to global so curve is in right spot
	#for debug drawing, uncomment both lines below, and add update call to _process
	
#	draw_set_transform(Vector2(-to_global(position)), rotation, scale)
#	draw_polyline(curve.get_baked_points(), Color.green, 20, true)
	pass
