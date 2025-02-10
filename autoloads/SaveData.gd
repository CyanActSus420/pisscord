extends Node

var config = ConfigFile.new()

var path = "user://fav_servers.cfg"

func save_fav_servers():
	config.set_value("file", "list", ServerData.favIPs)
	
	config.save(path)

func load_fav_servers():
	var file = config.load(path)
	
	if file != OK:
		push_warning("user://fav_servers.cfg doesnt exist or wasnt loaded properly")
		return
	
	ServerData.favIPs = config.get_value("file", "list")
