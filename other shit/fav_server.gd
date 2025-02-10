extends Control

var ip = "82.65.192.27"
var id = 0

@onready var button: Button = $Button

func setData(new_ip, new_id):
	ip = new_ip
	id = new_id

func _ready() -> void:
	button.text = ip

func _on_button_pressed() -> void:
	Global.join_new_server(ip)

func _on_button_2_pressed() -> void:
	ServerData.remove_fav_server(ip)
