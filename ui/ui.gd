extends Node

signal menu_opened(menu_name: StringName)
signal menu_closed(menu_name: StringName)

const UPGRADE_MENU = &"UpgradeMenu"

var open_menus: Array[StringName] = []

func open_menu(menu_name: StringName) -> void:
	if menu_name in open_menus:
		return
	open_menus.append(menu_name)
	menu_opened.emit(menu_name)

func close_menu(menu_name: StringName) -> void:
	open_menus.erase(menu_name)
	menu_closed.emit(menu_name)

func is_menu_open(menu_name: StringName) -> bool:
	return menu_name in open_menus

func is_any_menu_open() -> bool:
	return not open_menus.is_empty()
