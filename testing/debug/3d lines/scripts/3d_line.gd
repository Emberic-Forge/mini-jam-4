extends Control
class_name HandleLine

var start_pos : Vector2
var end_pos : Vector2
var color : Color
var width : float

func _draw() -> void:
	draw_line(start_pos, end_pos, color, width*2)
