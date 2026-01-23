extends Node

## WARNING: this this some extremely shitty spaghetti code that holds itself together with ducttape and dreams
## DO NOT FUCK AROUND WITH THIS WITHOUT TELLING remidu64
## shit prob runs horrible but who cares tbh

## TODO: fix strikethrough tag not showing up in the messages
## TODO: add support for size tag

## ISSUES: if u type (/"insert a valid tag here"), it WILL get turned into [/"insert a valid tag here"]
## no i am not fixing it, fuck you
## never-fucking-mind, it doesnt make it shit itself

var bbcode_formats:Array = ["b", "i", "u", "code", "color", "s", "right", "left", "center", "rainbow"] ## supported tags
var temp:Array = [] ## temporary array
var newText = "" ## formatted message

func sort_ascending(a, b): ## 2D array sorter
	if a[1] < b[1]:
		return true
	return false
	
func findallsub(string, substring): ## find all occurences of a substring in another string
	var copy = string
	var res = []
	var offset = 0
	var location = 0
	while string.find(substring) > -1:
		location = string.find(substring)
		offset = len(copy) - len(string)
		string = string.substr(location+len(substring))
		res.append(location+offset)
	return res
	
func format(text):
 ## init some values
	newText = text 
	var count = 0
	var temp_text = ""
	var tag = ""
	var temp2 = []
	var usages = 0
				
	for i in bbcode_formats:
		
		match i: 
			"b", "i", "u", "code", "s", "right", "left", "center", "rainbow": ## if its a simple tag, just add it list of tags
				temp2 = findallsub(newText, "["+i+"]")
				for j in temp2:
					temp.append([i, j, len(temp2)])
				
			"color": ## if its a tag with arguments, add the tag AND the arguments to the list
				temp2 = findallsub(newText, "["+i+"=")
				for j in temp2:
					temp.append([newText.substr(j+1, newText.substr(j).find("]")-1), j, len(temp2)])
			
	
	## sort and reverse the list
	temp.sort_custom(sort_ascending) 
	temp.reverse()
	
	for i in temp:
		tag = i[0].substr(0, i[0].find("=")) ## find the "=" character in the tag, if its not there (aka the "find" function return -1) then just take the whole tag, else take everything before the "="
		usages = i[2]
		
		if newText.count("[/"+tag+"]") < usages: ## if the user didnt close the tag, close it for them (gotta do this for lazy MFs)
			newText += "[/"+tag+"]"
			
	for i in temp: ## prevent the "[" at the start of the tags from being replaced by "[lb]"
		newText = newText.replace("["+i[0]+"]", "("+i[0]+")") 
		newText = newText.replace("[/"+i[0].substr(0, i[0].find("="))+"]", "(/"+i[0].substr(0, i[0].find("="))+")") ## same trick as the shit at line 47
	newText = newText.replace("[", "[lb]")
	for i in temp:
		newText = newText.replace("("+i[0]+")", "["+i[0]+"]")
		newText = newText.replace("(/"+i[0].substr(0, i[0].find("="))+")", "[/"+i[0].substr(0, i[0].find("="))+"]")
		
	return newText ## return the message duh
