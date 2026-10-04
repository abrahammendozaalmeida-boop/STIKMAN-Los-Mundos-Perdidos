extends Node

var changing_scene = false

func change_to(scene_path):
	if changing_scene:
		return false
	if not ResourceLoader.exists(scene_path):
		push_error("No existe la escena: " + str(scene_path))
		return false
	changing_scene = true
	var error = get_tree().change_scene(scene_path)
	changing_scene = false
	if error != OK:
		push_error("No se pudo abrir la escena: " + str(scene_path))
		return false
	return true
