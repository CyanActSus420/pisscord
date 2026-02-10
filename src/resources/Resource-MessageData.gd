class_name MessageData extends Resource

var MessageContent:String = ""
var Username:String = ""
var UserColor:String = "[color=white]"

func return_formatted() -> String:
	return "%s: %s" % [
		Username,
		MessageContent
	]
