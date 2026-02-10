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

## ------------------------------------------
## [ EVERYTHING THAT ISN'T THE THINGS BELOW ]
## ------------------------------------------

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

## -----------------
## [ RPC FUNCTIONS ]
## -----------------

@rpc("any_peer", "call_local")
func rpc_message(data:MessageData) -> void:
	Messages.text += "%s\n" % data.return_formatted()
