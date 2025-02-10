extends Node

var main = null
var fav_server_list = null

@onready var ping_time_out: Timer = $pingTimeOut
@onready var server_ping_timer: Timer = $serverPing

func join_new_server(serverip):
	if main != null:
		main.join_server(serverip)
	else:
		push_error("main is null")
