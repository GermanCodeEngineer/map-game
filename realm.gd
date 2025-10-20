extends Node2D

const WorldMap = preload("res://map.gd").WorldMap
const Province = preload("res://province.gd").Province

class Realm:
	var map: WorldMap
	var name: String
	var provinces: Array[Province]

	@warning_ignore("shadowed_variable")
	func _init(map: WorldMap, name: String, provinces: Array[Province]):
		self.map = map
		self.name = name
		self.provinces = provinces
	
	func capital_province() -> Province:
		return self.provinces[0]
