extends Control

func _draw():
	var curve : Curve3D= $Path3D.get_curve()
	for point in curve.point_count:
		var position = curve.get_point_position(point)
		var screen_position = get_viewport().get_camera_3d().unproject_position(position)
		draw_rect(Rect2(screen_position, Vector2(5,5)), Color.GREEN)
