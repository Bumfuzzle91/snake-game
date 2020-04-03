#snake_body.gd
extends Node2D

export(int) var width = 64
export(int) var length = 512
export(int) var resolution = 60

export(Texture) var scale_texture
export(CurveTexture) var distort_curve_texture

onready var path = $Path2D
onready var mesh = $PseudoMesh
onready var head = $Head


