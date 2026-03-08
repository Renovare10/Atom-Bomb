extends Control

signal selection_made(screen_rect: Rect2)

@export var border_thickness: float = 3.0
@export var border_color: Color = Color(0.78, 0.0, 0.9, 0.85)

var is_dragging: bool = false
var drag_start: Vector2
var drag_current: Vector2

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			drag_start = get_local_mouse_position()
			drag_current = drag_start
			queue_redraw()
		else:
			if is_dragging:
				if (drag_current - drag_start).length_squared() < 100:  # ~10 pixels in any direction
					# Quick click → clear selection
					selection_made.emit(Rect2())
				else:
					# Actual drag → normal selection
					_process_selection()
				is_dragging = false
				queue_redraw()

	elif event is InputEventMouseMotion and is_dragging:
		drag_current = get_local_mouse_position()
		queue_redraw()

func _process_selection() -> void:
	var min_pos: Vector2 = Vector2(
		min(drag_start.x, drag_current.x),
		min(drag_start.y, drag_current.y)
	)
	var rect_size: Vector2 = Vector2(
		abs(drag_current.x - drag_start.x),
		abs(drag_current.y - drag_start.y)
	)
	
	# Ignore tiny drags (width or height < 10px)
	if rect_size.x < 10.0 or rect_size.y < 10.0:
		return
	
	var screen_rect: Rect2 = Rect2(min_pos, rect_size)
	selection_made.emit(screen_rect)

func _draw() -> void:
	if not is_dragging:
		return
	
	var min_pos: Vector2 = Vector2(
		min(drag_start.x, drag_current.x),
		min(drag_start.y, drag_current.y)
	)
	var rect_size: Vector2 = Vector2(
		abs(drag_current.x - drag_start.x),
		abs(drag_current.y - drag_start.y)
	)
	
	var box_rect: Rect2 = Rect2(min_pos, rect_size)
	
	# Thick purple outline only (no fill)
	draw_rect(box_rect, border_color, false, border_thickness)
