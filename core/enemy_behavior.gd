extends Node

@export var wave_interval: float = 4.2          # total time between full attacks
@export var collection_radius: float = 650.0    # only balls this close to enemy core
@export var max_balls_per_wave: int = 7         # how many get redirected
@export var launch_speed: float = 520.0         # final attack speed
@export var spread_angle: float = 28.0          # degrees of random spread on launch

@export var rally_duration: float = 1.8         # how long balls move toward rally point
@export var rally_offset_factor: float = 0.35   # 0.0 = at core, 1.0 = halfway to player

@onready var core: Node2D = get_parent()

var player_core: Node2D
var timer: Timer

func _ready() -> void:
	# Find the opposite-team core (the player)
	for c in get_tree().get_nodes_in_group("cores"):
		if c.team != core.team:
			player_core = c
			break
	
	if not player_core:
		return
	
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = wave_interval
	timer.timeout.connect(_start_wave)
	timer.one_shot = false
	timer.start()


func _start_wave() -> void:
	if not player_core or not is_instance_valid(player_core):
		return
	
	# Collect candidates
	var candidates: Array[RigidBody2D] = []
	for ball in get_tree().get_nodes_in_group("energy"):
		if ball is RigidBody2D and ball.team == core.team:
			var dist = ball.global_position.distance_to(core.global_position)
			if dist <= collection_radius and dist > 40:
				candidates.append(ball)
	
	if candidates.is_empty():
		return
	
	candidates.shuffle()
	var to_rally = candidates.slice(0, max_balls_per_wave)
	
	if to_rally.is_empty():
		return
	
	# Calculate rally point: somewhere between us and the player
	var to_player = player_core.global_position - core.global_position
	var rally_point = core.global_position + to_player * rally_offset_factor
	
	# Phase 1: rally / gather
	for ball in to_rally:
		if not is_instance_valid(ball):
			continue
		
		var dir_to_rally = (rally_point - ball.global_position).normalized()
		# Slightly faster than normal movement so they visibly gather
		ball.linear_velocity = dir_to_rally * (launch_speed * 0.9)
		
		# Optional: quick visual cue that they're being commanded to rally
		var original_color = ball.modulate
		ball.modulate = Color(1.4, 1.4, 1.8, 1.0)  # slight blue-white tint
		var tween = ball.create_tween()
		tween.tween_property(ball, "modulate", original_color, rally_duration + 0.4)
	
	# Phase 2: after rally time, launch toward player
	await get_tree().create_timer(rally_duration).timeout
	
	for ball in to_rally:
		if not is_instance_valid(ball):
			continue
		
		var direction = (player_core.global_position - ball.global_position).normalized()
		direction = direction.rotated(deg_to_rad(randf_range(-spread_angle, spread_angle)))
		
		ball.linear_velocity = direction * launch_speed
		
		# Stronger launch flash
		var original_color = ball.modulate
		ball.modulate = Color.WHITE
		var tween = ball.create_tween()
		tween.tween_property(ball, "modulate", original_color, 0.35)
