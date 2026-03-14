extends Node2D

@export var energy_ball_scene: PackedScene
@export var spawn_rate: float = 0.4

@onready var timer: Timer = Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.timeout.connect(_spawn_energy_ball)
	timer.start(spawn_rate)

func _spawn_energy_ball() -> void:
	var ball = energy_ball_scene.instantiate() as RigidBody2D
	var container = get_tree().get_first_node_in_group("energy_balls")
	if container:
		container.add_child(ball)
	else:
		get_tree().current_scene.add_child(ball)
	
	ball.global_position = global_position
	
	var core = get_parent() as Node2D
	if core and "team" in core and "core_color" in core:
		ball.team = core.team
		ball.modulate = core.core_color
	
	var angle = randf_range(0, TAU)
	var direction = Vector2(cos(angle), sin(angle))
	ball.launch(direction)
	
	timer.start(spawn_rate)
