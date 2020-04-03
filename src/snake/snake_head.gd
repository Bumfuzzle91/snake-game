#snake_head.gd
extends Sprite

var body

func _ready():
	body = get_parent()

func _process(delta):
	var curve = body.path.curve
	var angle = (curve.get_point_position(0) - curve.get_point_position(1)).angle()
	
	self.rotation_degrees = rad2deg(angle)
