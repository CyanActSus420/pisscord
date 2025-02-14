extends Node2D

@onready var v_box_container: VBoxContainer = $VBoxContainer

const FAV_SERVER_NODE = preload("res://other shit/fav_server.tscn")

func _ready():
	Global.fav_server_list = self
	await get_tree().create_timer(1).timeout
	reload()

func reload():
	for i in v_box_container.get_children():
		i.queue_free()
	for i in ServerData.favIPs.size():
		var server_node = FAV_SERVER_NODE.instantiate()
		server_node.setData(str(ServerData.favIPs[i]), i)
		v_box_container.add_child(server_node)
