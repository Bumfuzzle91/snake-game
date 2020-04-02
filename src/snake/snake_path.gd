#snake_path.gd
extends Path2D

export(NodePath) var head_path
export var length = 512
export var resolution = 60

var head
onready var follow = $PathFollow2D

func _ready():
	head = get_node(head_path)
	curve.clear_points()

	#total number of points = resolution + 1
	for i in range(0, resolution + 1):
		var pos = Vector2(i * length/resolution, 0)
		
		curve.add_point(pos)

func _process(delta):
	curve.set_point_position(0, to_global(head.position))
	for i in range(0, curve.get_point_count()-1):
		var p1 = curve.get_point_position(i)
		var p2 = curve.get_point_position(i+1)

		var vec = p1 - p2
		vec = vec.normalized() * length / resolution	
		curve.set_point_position(i+1, p1 - vec)
	
func _draw():
	pass
	#draw_set_transform(Vector2(-to_global(position)), rotation, scale)
	#draw_polyline(curve.get_baked_points(), Color.green, 20, true)
