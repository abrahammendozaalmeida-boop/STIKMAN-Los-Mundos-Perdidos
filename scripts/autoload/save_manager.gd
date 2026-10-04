extends Node

const SAVE_PATH = "user://savegame.json"

var last_error = ""

func has_save():
	return File.new().file_exists(SAVE_PATH)

func save_game():
	var file = File.new()
	var error = file.open(SAVE_PATH, File.WRITE)
	if error != OK:
		last_error = "No se pudo abrir el archivo de guardado."
		return false
	file.store_string(to_json(GameState.to_save_data()))
	file.close()
	last_error = ""
	return true

func load_game():
	var file = File.new()
	if not file.file_exists(SAVE_PATH):
		last_error = "Todavía no hay una partida guardada."
		return false
	var error = file.open(SAVE_PATH, File.READ)
	if error != OK:
		last_error = "No se pudo leer la partida guardada."
		return false
	var text_data = file.get_as_text()
	file.close()
	var parsed = JSON.parse(text_data)
	if parsed.error != OK or typeof(parsed.result) != TYPE_DICTIONARY:
		last_error = "El archivo de guardado está dañado."
		return false
	if not GameState.apply_save_data(parsed.result):
		last_error = "La versión de la partida no es compatible."
		return false
	last_error = ""
	return true

func delete_save():
	var directory = Directory.new()
	if directory.file_exists(SAVE_PATH):
		return directory.remove(SAVE_PATH) == OK
	return true
