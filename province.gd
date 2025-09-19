extends Node2D

const utility = preload("res://utility.gd")
const WorldMap = preload("res://map.gd").WorldMap

const COLOR_SELECTED = Color(1, 1, 1, 1)

class Province:
	var parent: WorldMap
	var node: Node2D
	var row: int
	var col: int
	var position: Vector2
	var pointing_up: bool
	var name: String
	var population: int
	var color: Color

	@warning_ignore("shadowed_variable")
	func _init(
		parent: WorldMap, row: int, col: int, position: Vector2, pointing_up: bool,
		name: String, population: int, color: Color,
	):
		self.parent = parent
		self.node = Node2D.new()
		self.row = row
		self.col = col
		self.position = position
		self.pointing_up = pointing_up
		self.name = name
		self.population = population
		self.color = color
	
	func setup():
		self.node.position = self.position

		# Polygon2D visual
		var tri = Polygon2D.new()
		tri.polygon = utility.make_triangle(parent.province_size, self.pointing_up)
		tri.color = self.color
		self.node.add_child(tri)
		
		# Border line
		var tri_border = Line2D.new()
		tri_border.points = utility.make_triangle_border(parent.province_size, self.pointing_up, 4)
		tri_border.width = 4
		tri_border.default_color = Color.TRANSPARENT
		self.node.add_child(tri_border)
		
		# Area2D for clicks
		var area = Area2D.new()
		var collision = CollisionPolygon2D.new()
		collision.polygon = tri.polygon
		area.add_child(collision)
		area.connect("input_event", func(_viewport, event, _shape_idx):
			if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				self.on_click()
		)
		self.node.add_child(area)
	
	func update():
		var tri = self.node.get_child(0)
		var tri_border = self.node.get_child(1)
		var is_selected = self == self.parent.selected_province
		if is_selected:
			tri.color = self.color.darkened(-0.5).clamp(Color.BLACK, Color.WHITE.darkened(0.3))
			tri_border.default_color = Color.WHITE
		else:
			tri.color = self.color
			tri_border.default_color = Color.TRANSPARENT

	func on_click():
		print("Clicked province '%s', Population: %d" % [self.name, self.population])
		self.parent.selected_province = self
		var side_panel := self.parent.get_side_panel()
		var side_panel_vbox: VBoxContainer = side_panel.get_child(1)
		var province_name_label: Label = side_panel_vbox.get_child(0)
		province_name_label.text = self.name
		var province_population_label: Label = side_panel_vbox.get_child(1)
		province_population_label.text = "%d" % self.population
		self.parent.update()
