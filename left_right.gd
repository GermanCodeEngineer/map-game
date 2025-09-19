extends HBoxContainer

# Attach this to your HBoxContainer
@onready var sidebar = $SideBar  # Your left sidebar
@onready var main_area = $MapContainer      # Your main area
@onready var viewport_container = main_area.get_node("ViewportContainer")
@onready var subviewport = viewport_container.get_node("Viewport")

func _ready():
	# Sidebar fixed-ish, main area expands
	sidebar.size_flags_horizontal = Control.SIZE_FILL
	main_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	# Update SubViewport to match container at start
	_update_viewport_size()

	# Connect resized signal so SubViewport always matches container
	self.resized.connect(_update_viewport_size)
	
	viewport_container.resized.connect(_update_viewport_size)

func _update_viewport_size():
	# Make SubViewport match the main area's ViewportContainer
	if viewport_container and subviewport:
		subviewport.size = viewport_container.size

func _process(_delta):
	# Optional: enforce sidebar ~20% of total width
	var total_width = self.size.x
	sidebar.custom_minimum_size.x = max(total_width * 0.2, 1)
