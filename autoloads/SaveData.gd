extends Node

var config = ConfigFile.new()
var user_theme = ConfigFile.new()

var save_path = "user://fav_servers.cfg"
var theme_path = "user://user_theme.cfg"

func _ready() -> void:
	create_custom_theme()

func save_to_config(name_uwu: String, var_to_save):
	config.set_value("file", name_uwu, var_to_save)
	config.save(save_path)

func load_from_config(name_uwu: String):
	var file = config.load(save_path)
	
	if file != OK:
		push_warning("user://fav_servers.cfg doesnt exist or wasnt loaded properly")
		return
	
	return config.get_value("file", name_uwu)

func create_custom_theme():
	var file = user_theme.load(theme_path)
	
	if file != OK:
		push_warning("creating new user://user_theme.cfg file")
		# too lazy to make the code not shit
		user_theme.set_value("colors", "bg_color", ThemeManager.default_bg_color)
		user_theme.set_value("chat-menu", "chat_size", ThemeManager.default_chat_size)
		user_theme.set_value("chat-menu", "chat_position", ThemeManager.default_chat_position)
		user_theme.set_value("chat-menu", "input_size", ThemeManager.default_input_size)
		user_theme.set_value("chat-menu", "input_position", ThemeManager.default_input_position)
		user_theme.set_value("chat-menu", "leave_button_size", ThemeManager.default_leave_button_size)
		user_theme.set_value("chat-menu", "leave_button_position", ThemeManager.default_leave_button_position)
		user_theme.set_value("chat-menu", "send_size", ThemeManager.default_send_size)
		user_theme.set_value("chat-menu", "send_position", ThemeManager.default_send_position)
		user_theme.set_value("chat-menu", "clear_size", ThemeManager.default_clear_size)
		user_theme.set_value("chat-menu", "clear_position", ThemeManager.default_clear_position)
		user_theme.set_value("chat-menu", "ping_size", ThemeManager.default_ping_size)
		user_theme.set_value("chat-menu", "ping_position", ThemeManager.default_ping_position)
		
		user_theme.save(theme_path)

func load_custom_theme_property(shit:String, property_name:String):
	var file = user_theme.load(theme_path)
	
	if file != OK:
		push_warning("user://user_theme.cfg doesnt exist or wasnt loaded properly")
		return
	
	return user_theme.get_value(shit, property_name)
