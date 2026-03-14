extends CanvasLayer

var is_open := false

func _ready() -> void:
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("toggle_upgrades"):
		toggle_menu()
		get_viewport().set_input_as_handled()

func toggle_menu() -> void:
	is_open = !is_open
	
	if is_open:
		visible = true
		UI.open_menu(UI.UPGRADE_MENU)
	else:
		visible = false
		UI.close_menu(UI.UPGRADE_MENU)
