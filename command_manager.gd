extends Node2D

@export var selection_manager_path: NodePath = "../SelectionManager"

var selection_manager: Node

var is_commanding: bool = false

func _ready() -> void:
	selection_manager = get_node(selection_manager_path)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			var selected = selection_manager.get_selected_particles()
			if selected.is_empty():
				return
			is_commanding = true
			_update_targets()
		else:
			is_commanding = false

func _process(_delta: float) -> void:
	if is_commanding:
		_update_targets()

func _update_targets() -> void:
	var selected_particles: Array[Node2D] = selection_manager.get_selected_particles()
	if selected_particles.is_empty():
		is_commanding = false
		return
	
	var target_pos: Vector2 = get_global_mouse_position()
	
	for particle in selected_particles:
		if is_instance_valid(particle):
			var direction: Vector2 = (target_pos - particle.global_position).normalized()
			particle.launch(direction)
