extends Area2D

@export var speed: float = 400.0
@export var lifetime: float = 8.0

var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	$lifetime_timer.timeout.connect(queue_free)


func _physics_process(delta: float) -> void:
	position += velocity * delta

func launch(direction: Vector2) -> void:
	velocity = direction.normalized() * speed
