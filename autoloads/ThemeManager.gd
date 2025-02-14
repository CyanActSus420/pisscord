extends Node

var default_bg_color = Color("008080")
var default_chat_size = Vector2(1264, 568)
var default_chat_position = Vector2(-612, -332)
var default_input_size = Vector2(1184, 63)
var default_input_position = Vector2(-612, 244)
var default_leave_button_size = Vector2(88, 31)
var default_leave_button_position = Vector2(-612, 340)
var default_send_size = Vector2(72, 31)
var default_send_position = Vector2(580, 276)
var default_clear_size = Vector2(168, 31)
var default_clear_position = Vector2(484, 340)
var default_ping_size = Vector2(184, 31)
var default_ping_position = Vector2(292, 340)
var default_info_position = Vector2(-612, 316)
var default_usrcol_position = Vector2(484, -308)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("reset_theme"):
		reload_theme()

func reload_theme():
	# im a lil bit lazy to rewrite this :3
	Global.show_reloading()
	RenderingServer.set_default_clear_color(SaveData.load_custom_theme_property("colors", "bg_color"))
	Global.main.messages.size = SaveData.load_custom_theme_property("chat-menu", "chat_size")
	Global.main.messages.position = SaveData.load_custom_theme_property("chat-menu", "chat_position")
	Global.main.messages_bg.size = SaveData.load_custom_theme_property("chat-menu", "chat_size")
	Global.main.messages_bg.position = SaveData.load_custom_theme_property("chat-menu", "chat_position")
	Global.main.message.size = SaveData.load_custom_theme_property("chat-menu", "input_size")
	Global.main.message.position = SaveData.load_custom_theme_property("chat-menu", "input_position")
	Global.main.leave_button.size = SaveData.load_custom_theme_property("chat-menu", "leave_button_size")
	Global.main.leave_button.position = SaveData.load_custom_theme_property("chat-menu", "leave_button_position")
	Global.main.send.size = SaveData.load_custom_theme_property("chat-menu", "send_size")
	Global.main.send.position = SaveData.load_custom_theme_property("chat-menu", "send_position")
	Global.main.ping_button.size = SaveData.load_custom_theme_property("chat-menu", "ping_size")
	Global.main.ping_button.position = SaveData.load_custom_theme_property("chat-menu", "ping_position")
	Global.main.clear.size = SaveData.load_custom_theme_property("chat-menu", "clear_size")
	Global.main.clear.position = SaveData.load_custom_theme_property("chat-menu", "clear_position")
	Global.main.info.position = SaveData.load_custom_theme_property("chat-menu", "info_position")
	Global.main.username_color.position = SaveData.load_custom_theme_property("chat-menu", "usrcol_position")
