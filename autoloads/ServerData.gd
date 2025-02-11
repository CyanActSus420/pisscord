extends Node

var connectedUsers:int = 0

var curIP:String
var favIPs = []

var connectedUsersString:String = ""
var connectedUsersList:Array = []

func _ready():
	SaveData.load_from_config("list")

func add_fav_server(serverip):
	favIPs.append(serverip)
	SaveData.save_to_config("list", favIPs)

func remove_fav_server(serverip):
	for i in favIPs.size():
		if favIPs[i] == serverip:
			print(i)
			favIPs.remove_at(i)
			SaveData.save_to_config("list", favIPs)
			Global.fav_server_list.reload()
			break
