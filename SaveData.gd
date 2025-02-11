extends Node

var config = ConfigFile.new()

var path = "user://fav_servers.cfg"

func save_to_config(name_uwu: String, var_to_save):
	config.set_value("file", name_uwu, var_to_save)
	config.save(path)

func load_from_config(name_uwu: String):
	var file = config.load(path)
	
	if file != OK:
		push_warning("user://fav_servers.cfg doesnt exist or wasnt loaded properly")
		return
	
	return config.get_value("file", name_uwu)
