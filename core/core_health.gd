extends Node

@export var max_health: int = 10
var current_health: int = 10

@onready var core: Node2D = get_parent()
@onready var area: Area2D = $"../Area2D"

signal health_changed(new_health: int)
signal core_destroyed

func _ready() -> void:
	current_health = max_health
	
	# Safely connect the signal (works whether you connected it in the editor or not)
	if area and not area.body_entered.is_connected(_on_area_2d_body_entered):
		area.body_entered.connect(_on_area_2d_body_entered)

func _on_area_2d_body_entered(body: Node2D) -> void:
	# Only care about energy balls
	if not body is RigidBody2D or not "team" in body:
		return
	
	# Same team energy (including the ones your own EnergySpawner creates) → ignore completely
	if body.team == core.team:
		return
	
	# Enemy energy → damage core and destroy the energy
	current_health = max(current_health - 1, 0)
	health_changed.emit(current_health)
	
	# Destroy the incoming energy (uses the destroy() method you already have in energy.gd)
	if body.has_method("destroy"):
		body.destroy()
	else:
		body.queue_free()
	
	# Optional: you can handle game over / explosion in core.gd by connecting to this signal
	if current_health <= 0:
		core_destroyed.emit()
