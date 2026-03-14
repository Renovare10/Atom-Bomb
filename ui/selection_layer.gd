extends CanvasLayer

func _ready() -> void:
	UI.menu_opened.connect(_on_any_menu_opened)
	UI.menu_closed.connect(_on_any_menu_closed)
	visible = not UI.is_any_menu_open()

func _on_any_menu_opened(_menu: StringName) -> void:
	visible = false

func _on_any_menu_closed(_menu: StringName) -> void:
	visible = not UI.is_any_menu_open()
