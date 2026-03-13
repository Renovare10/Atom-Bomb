extends RigidBody2D

@export var speed: float = 400.0
@export var lifetime: float = 25.0
@export var selection_circle_radius: float = 24.0
@export var selection_circle_color: Color = Color(0.4, 0.8, 1.0, 0.9)
@export var selection_circle_width: float = 2.5

@export var team: StringName = &"neutral"

var is_selected: bool = false

func _ready() -> void:
	lock_rotation = true
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_on_body_entered)
	add_to_group("energy")
	
	$lifetime_timer.wait_time = lifetime
	$lifetime_timer.one_shot = true
	$lifetime_timer.start()
	$lifetime_timer.timeout.connect(queue_free)

func _on_body_entered(body: Node) -> void:
	if body is RigidBody2D and "team" in body and body.team != team:
		if body.has_method("destroy"):
			body.call_deferred("destroy")
		destroy()

func destroy() -> void:
	queue_free()

func _draw() -> void:
	if is_selected:
		draw_arc(Vector2.ZERO, selection_circle_radius, 0, TAU, 64, selection_circle_color, selection_circle_width)

func launch(direction: Vector2) -> void:
	linear_velocity = direction.normalized() * speed

func select() -> void:
	is_selected = true
	queue_redraw()

func unselect() -> void:
	is_selected = false
	queue_redraw()
