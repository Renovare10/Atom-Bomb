# core_health.gd
extends Node

@export var max_health: int = 10
var current_health: int = 10

var core: Node2D
var area: Area2D

signal health_changed(new_health: int)
signal core_destroyed

func _ready() -> void:
	current_health = max_health
	core = get_parent()

func set_area(new_area: Area2D) -> void:
	area = new_area
	if area and not area.body_entered.is_connected(_on_area_2d_body_entered):
		area.body_entered.connect(_on_area_2d_body_entered)

func get_health_ratio() -> float:
	return float(current_health) / max_health if max_health > 0 else 0.0

func _on_area_2d_body_entered(body: Node2D) -> void:
	# Only care about energy balls
	if not body is RigidBody2D or not "team" in body:
		return
	
	# Same team energy → ignore completely
	if body.team == core.team:
		return
	
	# Enemy energy → damage core and destroy the energy
	current_health = max(current_health - 1, 0)
	health_changed.emit(current_health)
	
	# Destroy the incoming energy
	if body.has_method("destroy"):
		body.destroy()
	else:
		body.queue_free()
	
	if current_health <= 0:
		core_destroyed.emit()
