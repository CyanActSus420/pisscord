extends Control

@onready var Messages: RichTextLabel = $MessagesPanel/Messages
@onready var MessageInput: TextEdit = $MessageInput

## ---------------------------
## [ DEFAULT GODOT FUNCTIONS ]
## ---------------------------

func _ready() -> void:
	get_tree().set_multiplayer(SceneMultiplayer.new(), self.get_path())
	multiplayer.multiplayer_peer = LocalUserData.peer
	multiplayer.allow_object_decoding = true
	
	var data:MessageData = MessageData.new()
	data.Username = "server"
	data.MessageContent = "%s has joined" % LocalUserData.Username
	rpc("rpc_message", data)

## -------------------------------------------------------
## [ EVERYTHING THAT ISN'T THE THINGS BELOW THIS SECTION ]
## -------------------------------------------------------

## function that begins the process of sending messages
func send_message() -> void:
	var data:MessageData = MessageData.new()
	data.Username = LocalUserData.Username
	data.MessageContent = MessageInput.text
	
	MessageInput.text = ""
	rpc("rpc_message", data)

## ------------------
## [ BUTTON SIGNALS ]
## ------------------

func _on_send_button_pressed() -> void:
	send_message()

func _on_leave_button_pressed() -> void:
	multiplayer.multiplayer_peer = null
	LocalUserData.client = null
	LocalUserData.peer = null
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")

## -----------------
## [ RPC FUNCTIONS ]
## -----------------

@rpc("any_peer", "call_local")
func rpc_message(data:MessageData) -> void:
	Messages.text += "%s\n" % data.return_formatted()
