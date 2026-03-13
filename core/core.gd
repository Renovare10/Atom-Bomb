extends Node2D

@export var team: StringName = &"friendly"
@export var core_color: Color = Color(0.47599506, 0.721965, 0.9999941, 1)

@onready var wCircle: Sprite2D = $Wcircle

func _ready() -> void:
	wCircle.modulate  = core_color
