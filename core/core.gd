# core.gd
extends Node2D

@export var team: StringName = &"friendly"
@export var core_color: Color = Color(0.47599506, 0.721965, 0.9999941, 1)

@onready var wCircle: Sprite2D = $Wcircle
@onready var core_health: Node = $CoreHealth
@onready var health_ring: Node2D = $HealthRing
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	wCircle.modulate = core_color
	
	if core_health:
		core_health.set_area(area_2d)
		core_health.health_changed.connect(_on_health_changed)
		core_health.core_destroyed.connect(_on_core_destroyed)
	
	if health_ring and core_health:
		health_ring.set_core_health(core_health)

func _on_health_changed(_new_health: int) -> void:
	var tween = create_tween()
	wCircle.modulate = Color.WHITE
	tween.tween_property(wCircle, "modulate", core_color, 0.25)

func _on_core_destroyed() -> void:
	queue_free()
