extends Node

var bbcode_formats:Array = ["b", "i", "u", "code"]
var temp:Array = []
var newText = ""

func sort_ascending(a, b):
	if a[1] < b[1]:
		return true
	return false

func format(text):
	newText = text

	for i in bbcode_formats:
		if newText.find("["+i+"]") > -1 and newText.find("[/"+i+"]") == -1:
			temp.append([i, newText.find("["+i+"]")])
	
	
	temp.sort_custom(sort_ascending)
	temp.reverse()
	for i in temp:
		newText += "[/"+i[0]+"]"
			
	for i in bbcode_formats:
		newText = newText.replace("["+i+"]", "("+i+")")
		newText = newText.replace("[/"+i+"]", "(/"+i+")")
		
	newText = newText.replace("[", "[lb]")
	
	for i in bbcode_formats:
		newText = newText.replace("("+i+")", "["+i+"]")
		newText = newText.replace("(/"+i+")", "[/"+i+"]")
		
	return newText
