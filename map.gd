extends Node2D

const utility = preload("res://utility.gd")
const Realm = preload("res://realm.gd").Realm
const Province = preload("res://province.gd").Province

class WorldMap:
	var node: Node2D
	var province_rows: int
	var province_cols: int
	var province_size: float
	var provinces: Dictionary[String, Province]
	var realms: Dictionary[String, Realm]
	var selected_province: Province
	
	@warning_ignore("shadowed_variable")
	func _init(node: Node2D, province_rows: int, province_cols: int, province_size: float):
		self.node = node
		self.province_rows = province_rows
		self.province_cols = province_cols
		self.province_size = province_size
		self.provinces = {}
		self.realms = {}
		self.selected_province = null
		
	func fill_content():
		var map_data = utility.read_json_file("res://map_data.json")
		var provinces_data = map_data["provinces"]
		for row in range(self.province_rows):
			for col in range(self.province_cols):
				@warning_ignore("integer_division")
				var x = (col - self.province_cols) * self.province_size / 2
				@warning_ignore("integer_division")
				var y = (row - self.province_rows) * (self.province_size * sqrt(3) / 2)
				var pointing_up = (row + col) % 2 == 0
				var pos = Vector2(x, y)
				var province_data = provinces_data[len(self.provinces)] 
				self.provinces[province_data["name"]] = Province.new(
					self, row, col, pos, pointing_up,
					province_data["name"], province_data["population"], Color.html(province_data["color"]),
				)
		print(self.provinces.keys())
		var realms_data = map_data["realms"]
		for realm_name in realms_data.keys():
			# For now, each realm has one province with the same name
			# Only a limited amount of the provinces exist, so only those realms should be created
			if realm_name not in self.provinces:
				continue
			var realm = Realm.new(self, realm_name, [])
			for province_name in realms_data[realm_name]["provinces"]:
				realm.provinces.append(self.provinces[province_name])
			self.realms[realm_name] = realm
		
	
	func setup():
		for province in self.provinces.values():
			province.setup()
			self.node.add_child(province.node)
	
	func update():
		for province in self.provinces.values():
			province.update()

	func get_side_panel() -> Panel:
		var map_area: Control = self.node.get_parent()
		var window = map_area.get_parent()
		var panel_layer = window.get_child(0)
		var panel_node = panel_layer.get_child(0)
		return panel_node

var map_instance: WorldMap = null

func _ready():
	map_instance = WorldMap.new(self, 8, 12, 100.0)
	map_instance.fill_content()
	map_instance.setup()
