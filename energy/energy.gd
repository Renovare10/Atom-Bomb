extends Area2D

@export var speed: float = 400.0
@export var lifetime: float = 8.0

@export var selection_circle_radius: float = 24.0
@export var selection_circle_color: Color = Color(0.4, 0.8, 1.0, 0.9)
@export var selection_circle_width: float = 2.5

var velocity: Vector2 = Vector2.ZERO
var is_selected: bool = false

func _ready() -> void:
	$lifetime_timer.timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	position += velocity * delta

func _draw() -> void:
	if is_selected:
		draw_arc(Vector2.ZERO, selection_circle_radius, 0, TAU, 64, selection_circle_color, selection_circle_width)

func launch(direction: Vector2) -> void:
	velocity = direction.normalized() * speed

func select() -> void:
	is_selected = true
	queue_redraw()

func unselect() -> void:
	is_selected = false
	queue_redraw()
