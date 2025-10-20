extends Node2D

const utility = preload("res://utility.gd")
const WorldMap = preload("res://map.gd").WorldMap
const Realm = preload("res://realm.gd").Realm

const COLOR_SELECTED = Color(1, 1, 1, 1)

class Province:
	var map: WorldMap
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
		map: WorldMap, row: int, col: int, position: Vector2, pointing_up: bool,
		name: String, population: int, color: Color
	):
		self.map = map
		self.node = Node2D.new()
		self.row = row
		self.col = col
		self.position = position
		self.pointing_up = pointing_up
		
		self.name = name
		self.population = population
		self.color = color
	
	# Graphic APIs
	func setup():
		self.node.position = self.position

		# Polygon2D visual
		var tri = Polygon2D.new()
		tri.polygon = utility.make_triangle(map.province_size, self.pointing_up)
		tri.color = self.color
		self.node.add_child(tri)
		
		# Border line
		var tri_border = Line2D.new()
		tri_border.points = utility.make_triangle_border(map.province_size, self.pointing_up, 4)
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
		var is_selected = self == self.map.selected_province
		tri.color = self.get_color(is_selected)
		tri_border.default_color = Color.WHITE if is_selected else Color.TRANSPARENT

	# Read-only Properties
	func realm() -> Realm:
		for realm in self.map.realms.values():
			if self in realm.provines:
				return realm
		assert(false, "Province has no realm")
		return null
	
	# Helpers
	func get_color(is_selected: bool) -> Color:
		@warning_ignore("shadowed_variable")
		var color = self.color
		if is_selected:
			return color.darkened(-0.5).clamp(Color.BLACK, Color.WHITE.darkened(0.3))
		else:
			return color
	
	func on_click():
		print("Clicked province '%s', Population: %d" % [self.name, self.population])
		self.map.selected_province = self
		var side_panel := self.map.get_side_panel()
		var side_panel_vbox: VBoxContainer = side_panel.get_child(1)
		var province_name_label: Label = side_panel_vbox.get_child(0)
		province_name_label.text = self.name
		var province_population_label: Label = side_panel_vbox.get_child(1)
		province_population_label.text = "%d" % self.population
		self.map.update()
