extends Node

var server = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var args = Array(OS.get_cmdline_args())
	if args.has("-server"):
		server = true
