extends Node

@export var selection_manager_path: NodePath = "../SelectionManager"

var selection_manager: Node

func _ready() -> void:
	selection_manager = get_node(selection_manager_path)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		var selected_particles: Array[Node2D] = selection_manager.get_selected_particles()
		if selected_particles.is_empty():
			return
		
		var reference_node: Node2D = selected_particles[0]
		
		var target_pos: Vector2 = reference_node.get_global_mouse_position()
		
		for particle in selected_particles:
			if is_instance_valid(particle):
				var direction: Vector2 = (target_pos - particle.global_position).normalized()
				particle.launch(direction)
