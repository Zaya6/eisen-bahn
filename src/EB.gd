extends Node

var stampLibraries = {}

func _init():
	#start loading libraries at start
	loadStampLibrary()

func loadStampLibrary(path="res://src/stamps/libraries"):
	var dir = Directory.new()
	var libraries = {}
	dir.open(path)
	dir.list_dir_begin()
	
	print("Loading stamp libraries")
	# Get every file in directory
	while true:
		var file = dir.get_next()
		if file == "":
			break
		if file.ends_with(".json"):
			var name = file
			print(name)
			name.erase(name.length()-5,name.length())
			processStampLibrary(name, path+file)
	dir.list_dir_end()
	print("done")
	

func processStampLibrary(name, path):
	#load and parse json file into dictionary
	var library = {}
	var file = File.new()
	file.open(path, file.READ)
	library = parse_json(file.get_as_text())
	file.close()
	#add library under name to dictionary
	stampLibraries[name] = library