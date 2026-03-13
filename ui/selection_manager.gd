extends Node

signal particles_selected(selected: Array[Node2D])

@export var selection_box_path: NodePath = "../../SelectionLayer/SelectionBox"
@export var player_team: StringName = &"friendly"  # Change this to match your player's core team

var selection_box: Control
var selected_particles: Array[Node2D] = []

func _ready() -> void:
	selection_box = get_node(selection_box_path)
	selection_box.selection_made.connect(_on_selection_made)

func _on_selection_made(screen_rect: Rect2) -> void:
	deselect_all()
	var newly_selected: Array[Node2D] = []
	
	# Loop over all energies and filter by our player's team
	for particle in get_tree().get_nodes_in_group("energy"):
		if particle.team != player_team:
			continue  # Skip enemy/neutral/other teams
		
		# Convert particle's global position to screen space
		var screen_pos: Vector2 = particle.get_global_transform_with_canvas().origin
		
		if screen_rect.has_point(screen_pos):
			select_particle(particle)
			newly_selected.append(particle)
	
	selected_particles = newly_selected
	particles_selected.emit(selected_particles)

func select_particle(particle: Node2D) -> void:
	if is_instance_valid(particle):
		particle.select()

func deselect_all() -> void:
	for i in range(selected_particles.size() - 1, -1, -1):
		var particle = selected_particles[i]
		if is_instance_valid(particle):
			particle.unselect()
		selected_particles.remove_at(i)

# Public helpers
func get_selected_particles() -> Array[Node2D]:
	var valid: Array[Node2D] = []
	for p in selected_particles:
		if is_instance_valid(p):
			valid.append(p)
	return valid

func clear_selection() -> void:
	deselect_all()
