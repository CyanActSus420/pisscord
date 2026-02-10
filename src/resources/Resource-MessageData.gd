class_name MessageData extends Resource

@export var MessageContent:String = ""
@export var Username:String = ""
@export var UserColor:String = "[color=white]"

func return_formatted() -> String:
	return "%s: %s" % [
		Username,
		MessageContent
	]
