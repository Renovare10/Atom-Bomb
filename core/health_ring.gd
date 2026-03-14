# health_ring.gd
extends Node2D

@export var ring_radius: float = 80.0
@export var ring_thickness: float = 12.0
@export var full_color: Color = Color(0.2, 0.9, 0.3, 0.9)
@export var empty_color: Color = Color(0.9, 0.2, 0.2, 0.9)
@export var segments: int = 64
@export var fade_duration: float = 4.0

var current_health: float = 1.0
var fade_tween: Tween = null
var core_health_component: Node = null

func _ready() -> void:
	z_index = 1
	modulate.a = 0.0

func set_core_health(health_node: Node) -> void:
	core_health_component = health_node
	if core_health_component:
		if not core_health_component.health_changed.is_connected(_on_health_changed):
			core_health_component.health_changed.connect(_on_health_changed)
		current_health = core_health_component.get_health_ratio()
		queue_redraw()

func _on_health_changed(_new_health: int) -> void:
	if not core_health_component:
		return
	
	var new_ratio = core_health_component.get_health_ratio()
	
	if new_ratio < current_health:
		modulate.a = 1.0
		if fade_tween:
			fade_tween.kill()
	
	current_health = new_ratio
	queue_redraw()
	
	fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 0.0, fade_duration)

func _draw() -> void:
	if current_health <= 0:
		return
	
	var t = 1.0 - current_health
	var color = full_color.lerp(empty_color, t)
	
	var angle_span = current_health * TAU
	if angle_span >= TAU - 0.001:
		angle_span = TAU - 0.001
	
	draw_arc(
		Vector2.ZERO,
		ring_radius,
		-PI / 2,
		-PI / 2 - angle_span,
		segments,
		color,
		ring_thickness,
		true
	)
