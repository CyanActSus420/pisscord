extends Node

## WARNING: this this some extremely shitty spaghetti code that holds itself together with ducttape and dreams
## DO NOT FUCK AROUND WITH THIS WITHOUT TELLING remidu64
## shit prob runs horrible but who cares tbh

## TODO: fix strikethrough tag not showing up in the messages
## TODO: add support for size tag
## TODO: fix multiple tags making the formatter shit in the bed

## ISSUES: if u type (/"insert a valid tag here"), it WILL get turned into [/"insert a valid tag here"]
## no i am not fixing it, fuck you

var bbcode_formats:Array = ["b", "i", "u", "code", "color", "s"] ## supported tags
var temp:Array = [] ## temporary array
var newText = "" ## formatted message

func sort_ascending(a, b): ## 2D array sorter
	if a[1] < b[1]:
		return true
	return false

func format(text):
 ## init some values
	newText = text 
	var count = 0
	var temp_text = ""
	var tag = ""

	for i in bbcode_formats:
		count = 0
		temp_text = ""
		
		match i: 
			"b", "i", "u", "code", "s": ## if its a simple tag, just add it list of tags
				if newText.find("["+i+"]") > -1: 
					temp.append([i, newText.find("["+i+"]")])
				
			"color": ## if its a tag with arguments, add the tag AND the arguments to the list
				if newText.find("["+i+"=") > -1:
					while newText[newText.find(i)+count] != "]":	
						temp_text += newText[newText.find(i)+count]
						count += 1
						
					temp.append([temp_text, newText.find("["+i+"=")])
	
	 ## sort and reverse the list
	temp.sort_custom(sort_ascending) 
	temp.reverse()
	
	for i in temp:
		tag = i[0].substr(0, i[0].find("=")) ## find the "=" character in the tag, if its not there (aka the "find" function return -1) then just take the whole tag, else take everything before the "="
			
		if newText.find("[/"+tag+"]") == -1: ## if the user didnt close the tag, close it for them (gotta do this for lazy MFs)
			newText += "[/"+tag+"]"
			
	for i in temp: ## prevent the "[" at the start of the tags from being replaced by "[lb]"
		newText = newText.replace("["+i[0]+"]", "("+i[0]+")") 
		newText = newText.replace("[/"+i[0].substr(0, i[0].find("="))+"]", "(/"+i[0].substr(0, i[0].find("="))+")") ## same trick as the shit at line 47
	newText = newText.replace("[", "[lb]")
	for i in temp:
		newText = newText.replace("("+i[0]+")", "["+i[0]+"]")
		newText = newText.replace("(/"+i[0].substr(0, i[0].find("="))+")", "[/"+i[0].substr(0, i[0].find("="))+"]")
		
	return newText ## return the message duh
