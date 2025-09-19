extends Camera2D

@export var move_speed := 400.0   # pixels per second
@export var zoom_step := 0.1      # how much to zoom per step
@export var min_zoom := 0.5       # max zoom-in
@export var max_zoom := 3.0       # max zoom-out

func _process(delta: float) -> void:
	# Movement
	var direction := Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	global_position += direction.normalized() * move_speed * delta

	# Zoom in/out
	if Input.is_action_just_pressed("zoom_in"):
		zoom = (zoom - Vector2.ONE * zoom_step).clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
	if Input.is_action_just_pressed("zoom_out"):
		zoom = (zoom + Vector2.ONE * zoom_step).clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
