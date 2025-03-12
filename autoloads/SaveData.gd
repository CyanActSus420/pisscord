extends Node

var config = ConfigFile.new()
var theme_manager_file = ConfigFile.new()
var user_theme = ConfigFile.new()

var usedTheme = "base_theme"

var save_path = "user://fav_servers.cfg"
var theme_manager = "user://theme-manager.cum"
var base_theme_path = "user://base_theme.cbt"

var cur_path = "user://base_theme.cbt"

func _ready() -> void:
	create_base_theme()
	create_theme_manager()
	
	set_path()

func save_to_config(name_uwu: String, var_to_save):
	config.set_value("file", name_uwu, var_to_save)
	config.save(save_path)

func load_from_config(name_uwu: String):
	var file = config.load(save_path)
	
	if file != OK:
		push_error("user://fav_servers.cfg doesnt exist or wasnt loaded properly")
		return
	
	return config.get_value("file", name_uwu)

func create_theme_manager():
	var file = theme_manager_file.load(theme_manager)
	
	if file != OK:
		theme_manager_file.set_value("theme-management", "user_theme_file_name", "base_theme")
		
		theme_manager_file.save(theme_manager)

func create_base_theme():
	var file = user_theme.load(base_theme_path)
	
	if file != OK:
		print("creating new user://base_theme.cfg file")
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
		user_theme.set_value("chat-menu", "info_position", ThemeManager.default_info_position)
		user_theme.set_value("chat-menu", "usrcol_position", ThemeManager.default_usrcol_position)
		
		user_theme.save(base_theme_path)

func set_path():
	var file = theme_manager_file.load(theme_manager)
	
	var themeName = theme_manager_file.get_value("theme-management", "user_theme_file_name")
	
	cur_path = "user://%s.cbt" % themeName

func load_custom_theme_property(shit:String, property_name:String):
	var file = user_theme.load(cur_path)
	
	if file != OK:
		push_error("user://user_theme.cfg doesnt exist or wasnt loaded properly")
		return
	
	var value = user_theme.get_value(shit, property_name)
	
	print(value)
	return value
