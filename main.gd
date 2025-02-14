extends Node2D
@onready var host_join: Node2D = $"host-join"
@onready var chat_shit: CanvasLayer = $chatShit/layer

# join shit
@onready var host: Button = $"host-join/host"
@onready var join: Button = $"host-join/join"
@onready var error_label: Label = $"host-join/errorLabel"
@onready var ip_edit: LineEdit = $"host-join/ipEdit"
@onready var port_edit: LineEdit = $"host-join/portEdit"
@onready var user_edit: LineEdit = $"host-join/LineEdit"
@onready var censor_ip: CheckBox = $"host-join/censorIP"

# "please wait" screen
@onready var wait: Node2D = $wait

# general chat node
@onready var chat: Control = $chatShit/layer/chat
# chat shit
@onready var messages_bg: TextEdit = $"chatShit/layer/chat/messages-old"
@onready var username_color: OptionButton = $chatShit/layer/chat/usernameColor
@onready var label_color: Label = $chatShit/layer/chat/usernameColor/Label
@onready var messages: RichTextLabel = $chatShit/layer/chat/messages
@onready var message = $chatShit/layer/chat/message
@onready var send: Button = $chatShit/layer/chat/send
@onready var info: Label = $chatShit/layer/chat/info
@onready var leave_button: Button = $chatShit/layer/chat/leave
@onready var clear: Button = $chatShit/layer/chat/clear
@onready var ping_button: Button = $chatShit/layer/chat/ping

# host settings screen
@onready var host_settings: Control = $chatShit/layer/hostSettings

var msg:String

func _ready() -> void:
	Global.main = self
	host_join.visible = true
	chat_shit.visible = false
	wait.visible = false
	chat.visible = true
	host_settings.visible = false
	
	Global.server_ping_timer.timeout.connect(check_users)
	
	if SaveData.load_from_config("color"):
		LocalUserData.color = SaveData.load_from_config("color")
	else:
		SaveData.save_to_config("color", "white")
		
	if not SaveData.load_from_config("name"):
		SaveData.save_to_config("name", "The FitnessGram™ Pacer Test is a multistage aerobic capacity test that progressively gets more difficult as it continues. The 20 meter pacer test will begin in 30 seconds. Line up at the start. The running speed starts slowly, but gets faster each minute after you hear this signal. [beep] A single lap should be completed each time you hear this sound. [ding] Remember to run in a straight line, and run as long as possible. The second time you fail to complete a lap before the sound, your test is over. The test will begin on the word start. On your mark, get ready, start.")
		# the shit above is funny, dont @ me
		# i couldve put the whole vaporeon copypasta if i wanted, so be happy i only put the fitnessgram pacer test lmfao
		# - remidu64
	
	if LaunchArgs.server:
		_on_host_2_pressed()
	
	ThemeManager.reload_theme()

func _physics_process(delta: float) -> void:
	if LocalUserData.connected:
		if !censor_ip.button_pressed:
			info.text = "username: %s | connected to: %s | connected users: %s" % [LocalUserData.username, LocalUserData.serverIP, ServerData.connectedUsers]
		else:
			info.text = "username: %s | censor ip is on | connected users %s" % [LocalUserData.username, ServerData.connectedUsers]
	
	if Input.is_action_just_pressed("send") and !Input.is_action_pressed("shift") and !host_settings.visible:
		send_message()
	
	if Input.is_action_just_pressed("host") and LocalUserData.host and !LocalUserData.dedicated_server:
		host_settings.visible = !host_settings.visible
	
	$chatShit/layer/chat/info2.visible = LocalUserData.host
	ip_edit.secret = censor_ip.button_pressed
	
	TextFormatting.temp = []

func _on_host_2_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(19132)
	get_tree().set_multiplayer(SceneMultiplayer.new(), self.get_path())
	multiplayer.multiplayer_peer = peer
	LocalUserData.host = true
	LocalUserData.dedicated_server = true
	DisplayServer.window_set_title("pisscord (dedicated server mode)")
	
	host_join.visible = false
	chat.visible = false
	chat_shit.visible = true
	host_settings.visible = true
	Global.server_ping_timer.start()
	$chatShit/layer/hostSettings/Label.text = "dedicated server"

func _on_host_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(19132)
	get_tree().set_multiplayer(SceneMultiplayer.new(), self.get_path())
	multiplayer.multiplayer_peer = peer
	LocalUserData.host = true
	Global.server_ping_timer.start()
	joined("localhost")

func _on_join_pressed() -> void:
	if ip_edit.text != "":
		LocalUserData.guest = false
		join_server(ip_edit.text)
	else:
		triggerError("enter server ip")

@rpc ("any_peer", "call_local")
func message_rpc(usrnm, data, usrcolor):
	if !LocalUserData.dedicated_server:
		if usrcolor == "rainbow":
			messages.text += str("[rainbow]", usrnm, ": [/rainbow]", "[color=dim_gray](", Time.get_time_string_from_system(), ")[/color]\n", data, "\n")
		else:
			messages.text += str("[color=", usrcolor, "]", usrnm, ": [/color]", "[color=dim_gray](", Time.get_time_string_from_system(), ")[/color]\n", data, "\n")

@rpc ("any_peer", "call_local")
func do_thing_to_user(usrnm:String, action:String):
	if LocalUserData.username == usrnm:
		match (action):
			"kick":
				triggerError("you've been kicked out", "Client Kicked")
			"usrnmban":
				triggerError("your username has been banned on this server", "Banned Username")
	
# used to send a message that only the person sending should see
@rpc ("any_peer", "call_local")
func message_rpc_client(usrnm, data, usrcolor, usrsending):
	if usrsending == LocalUserData.username:
		Global.ping_time_out.stop()
		messages.text += str("\n", "[color=", usrcolor, "]", usrnm, ": [/color]", "[color=dim_gray](", Time.get_time_string_from_system(), ")[/color]\n", data)

@rpc ("any_peer", "call_local")
func send_out_username_request():
	ServerData.connectedUsersList = []
	if !LocalUserData.dedicated_server:
		rpc("return_username_request", LocalUserData.username)
	else:
		get_total_users()

@rpc ("any_peer", "call_local")
func return_username_request(usrnm):
	if LocalUserData.host:
		ServerData.connectedUsersList.append(usrnm)
		get_total_users()

func get_total_users():
	ServerData.connectedUsersString = ""
	for i in ServerData.connectedUsersList.size():
		ServerData.connectedUsersString += "\n" + ServerData.connectedUsersList[i]
	await get_tree().create_timer(1).timeout
	rpc("update_connected_users", ServerData.connectedUsersString, ServerData.connectedUsersList.size()) 

@rpc ("any_peer", "call_local")
func update_connected_users(label_text:String, amount:int):
	$"chatShit/layer/hostSettings/Label2".text = "connected users: " + label_text
	ServerData.connectedUsers = amount

func check_users():
	ServerData.connectedUsersString = ""
	ServerData.connectedUsersList = []
	rpc("send_out_username_request")

func join_server(serverip:String):
	var peer = ENetMultiplayerPeer.new()
	var client = peer.create_client(serverip, 19132)
	get_tree().set_multiplayer(SceneMultiplayer.new(), self.get_path())
	multiplayer.multiplayer_peer = peer
	joined(serverip)

func joined(serverip:String):
	host_join.hide()
	wait.show()
	if !LocalUserData.guest and user_edit.text != "john roblox" and user_edit.text:
		LocalUserData.username = user_edit.text
		SaveData.save_to_config("name", user_edit.text)
	elif !LocalUserData.guest:
		LocalUserData.username = SaveData.load_from_config("name")
	else:
		LocalUserData.username = "Guest %s" % randi_range(0, 10000) 
	await get_tree().create_timer(1).timeout
	if LocalUserData.username != "":
		if LocalUserData.username == "[CLIENT]" or LocalUserData.username == "[SERVER]":
			triggerError("this username is not allowed")
			return
		if LocalUserData.username == "john roblox":
			triggerError("this username is not allowed (don't ask.)")
		
		
		LocalUserData.serverIP = serverip
		LocalUserData.serverPort = int(ip_edit.text)
		LocalUserData.connected = true
		addUser()
	else:
		triggerError("please put an actual username")

func addUser(guests_allowed:bool = true):
	rpc("message_rpc","[SERVER]",str(LocalUserData.username) + " has joined", "sky_blue")
	wait.hide()
	chat_shit.show()

func triggerError(errortext:String, leave_reason:String = "Client Error"):
	error_label.text = errortext
	leave(leave_reason)

func leave(reason:String):
	rpc("message_rpc","[SERVER]",str(LocalUserData.username) + " has left (" + reason + ")", "sky_blue")
	host_join.hide()
	wait.show()
	chat_shit.hide()
	await get_tree().create_timer(1).timeout
	LocalUserData.host = false
	LocalUserData.leave = false
	host_join.show()
	wait.hide()
	messages.text = ""
	multiplayer.multiplayer_peer = null

func send_message():
	if message.text != "" and LocalUserData.connected:
		rpc("message_rpc",LocalUserData.username,TextFormatting.format(message.text),LocalUserData.color)
		message.text = ""

func _on_send_pressed() -> void:
	send_message()

func _on_option_button_item_selected(index: int) -> void:
	LocalUserData.color = username_color.get_item_text(index)
	SaveData.save_to_config("color", LocalUserData.color)

func _on_join_2_pressed() -> void:
	if ip_edit.text != "":
		LocalUserData.guest = true
		join_server(ip_edit.text)
	else:
		triggerError("enter server ip")

func _on_clear_pressed() -> void:
	messages.text = "[color=steel_blue][CLIENT]:[/color] cleared chat\n"

func _on_leave_pressed() -> void:
	leave("Client Disconnect")
	messages.text = ""

func _on_fav_pressed() -> void:
	if ServerData.favIPs.size() == 9:
		triggerError("cant add more servers to fav list (i gotta rewrite this shit FAST)") # this shit aint never gon get rewrote lmfao
		return
	ServerData.add_fav_server(ip_edit.text)
	$"host-join/fav_server_list".reload()

func _on_ping_pressed() -> void:
	print("shit")
	Global.ping_time_out.start()
	rpc("message_rpc_client","[CLIENT]","server received the ping, you are still connected","steel_blue", LocalUserData.username)
	await Global.ping_time_out.timeout
	message_rpc("[CLIENT]", "server did not receive the ping, you are not connected", "steel_blue")

func _on_kick_pressed() -> void:
	rpc("do_thing_to_user", $chatShit/layer/hostSettings/LineEdit.text, "kick")
	$chatShit/layer/hostSettings/LineEdit.text == ""
