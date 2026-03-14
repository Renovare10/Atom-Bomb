extends Node2D

@export var ring_radius: float = 80.0
@export var ring_thickness: float = 12.0
@export var full_color: Color = Color(0.2, 0.9, 0.3, 0.9)
@export var empty_color: Color = Color(0.9, 0.2, 0.2, 0.9)
@export var segments: int = 64
@export var fade_duration: float = 4.0

var current_health: float = 1.0
var fade_tween: Tween = null

func _ready() -> void:
	z_index = 1
	modulate.a = 0.0
	var core_health = get_parent().get_node("CoreHealth")
	if core_health:
		core_health.health_changed.connect(_on_health_changed)
		current_health = float(core_health.current_health) / core_health.max_health

func _on_health_changed(new_health: int) -> void:
	var max_health = 10
	var new_ratio = float(new_health) / max_health
	
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
