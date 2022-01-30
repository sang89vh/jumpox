tool
extends Button


export(String, FILE) var next_scene_path: = ""


func _on_button_up() -> void:
	print_debug("_on_button_up clicked")
	PlayerData.reset()
	var ok: = get_tree().change_scene(next_scene_path)
	print_debug("change screen okie" + str(ok))


func _get_configuration_warning() -> String:
	return "The property Next Level can't be empty" if next_scene_path == "" else ""
