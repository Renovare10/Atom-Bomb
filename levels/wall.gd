extends StaticBody2D

@onready var collision_polygon: CollisionPolygon2D = $CollisionPolygon2D
@onready var line: Line2D = $Line2D

@export var line_color: Color = Color.RED

func _ready() -> void:
	update_line()

func update_line() -> void:
	var points: PackedVector2Array = collision_polygon.polygon
	if points.size() > 0:
		points.append(points[0])
	line.points = points
	line.default_color = line_color  # Apply the color
