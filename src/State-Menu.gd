extends Control

@onready var VersionLabel: Label = $VersionLabel

@onready var NameInput: LineEdit = $VBoxContainer/NameInput

@onready var PortInput: LineEdit = $VBoxContainer/HBoxContainer2/PortInput
@onready var ServerIpInput: LineEdit = $VBoxContainer/HBoxContainer2/ServerIpInput

func _ready() -> void:
	VersionLabel.text = ProjectSettings.get_setting("application/config/version")

func _on_join_button_pressed() -> void:
	LocalUserData.Username = NameInput.text
	join_server(ServerIpInput.text)

# TODO: add guest support
func _on_join_as_guest_button_pressed() -> void:
	LocalUserData.Username = "Guest %s" % randi_range(1, 10000)
	join_server(ServerIpInput.text)

func _on_host_button_pressed() -> void:
	LocalUserData.Username = NameInput.text
	LocalUserData.peer = ENetMultiplayerPeer.new()
	LocalUserData.peer.create_server(int(PortInput.text))
	common_server_shit()

func join_server(serverip:String):
	LocalUserData.peer = ENetMultiplayerPeer.new()
	LocalUserData.client = LocalUserData.peer.create_client(serverip, int(PortInput.text))
	common_server_shit()

func common_server_shit():
	# TODO: add a "loading" screen
	get_tree().change_scene_to_file("res://scenes/Chat.tscn")
