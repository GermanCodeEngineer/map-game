static func make_triangle(side: float, up: bool) -> PackedVector2Array:
	var h = side * sqrt(3) / 2.0
	if up:
		return PackedVector2Array([Vector2(-side/2, h/2), Vector2(side/2, h/2), Vector2(0, -h/2)])
	else:
		return PackedVector2Array([Vector2(-side/2, -h/2), Vector2(side/2, -h/2), Vector2(0, h/2)])

static func make_triangle_border(side: float, up: bool, inset: float) -> PackedVector2Array:
	var points = make_triangle(side, up)
	
	# compute centroid
	var center = Vector2()
	for p in points:
		center += p
	center /= points.size()
	
	# shrink each vertex toward center
	var inset_points = PackedVector2Array()
	for p in points:
		var dir = (p - center).normalized()
		inset_points.append(p - dir * inset)
	
	# close the loop
	inset_points.append(inset_points[0])
	return inset_points

static func read_json_file(path: String):
	var content_string = FileAccess.get_file_as_string(path)
	return JSON.parse_string(content_string)
