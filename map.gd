extends Node2D

const utility = preload("res://utility.gd")
const Province = preload("res://province.gd").Province

class WorldMap:
	var node: Node2D
	var province_rows: int
	var province_cols: int
	var province_size: float
	var provinces: Array[Province]
	var selected_province: Province
	
	@warning_ignore("shadowed_variable")
	func _init(node: Node2D, province_rows: int, province_cols: int, province_size: float):
		self.node = node
		self.province_rows = province_rows
		self.province_cols = province_cols
		self.province_size = province_size
		self.provinces = []
		self.selected_province = null
		
	func generate_provinces():
		var provinces_data = utility.read_json_file("res://province_data.json")
		for row in range(self.province_rows):
			for col in range(self.province_cols):
				@warning_ignore("integer_division")
				var x = (col - (self.province_cols/2)) * self.province_size / 2
				@warning_ignore("integer_division")
				var y = (row - (self.province_rows/2)) * (self.province_size * sqrt(3) / 2)
				var pointing_up = (row + col) % 2 == 0
				var pos = Vector2(x, y)
				var province_data = provinces_data[len(self.provinces)] 
				self.provinces.append(Province.new(
					self, row, col, pos, pointing_up,
					province_data["name"], province_data["population"], Color.html(province_data["color"]),
				))
		
	func setup():
		for province in self.provinces:
			province.setup()
			self.node.add_child(province.node)
	
	func update():
		for province in self.provinces:
			province.update()

func _ready():
	var map = WorldMap.new(self, 12, 12, 100.0)
	map.generate_provinces()
	map.setup()
