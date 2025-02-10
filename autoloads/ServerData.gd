extends Node

var connectedUsers:int = 0

var curIP:String
var favIPs = []

var connectedUsersList:Array = []

func _ready():
	SaveData.load_fav_servers()

func add_fav_server(serverip):
	favIPs.append(serverip)
	SaveData.save_fav_servers()

func remove_fav_server(serverip):
	for i in favIPs.size():
		if favIPs[i] == serverip:
			print(i)
			favIPs.remove_at(i)
			SaveData.save_fav_servers()
			Global.fav_server_list.reload()
			break
