tool
extends Node

export(String, FILE, "*.json") var StampLibraryPath
export(String) var stampName = ""
export(Vector2) var Probability = Vector2(1,1)
export(int) var limitSpawns = -1
export(bool) var rotation = false
export(bool) var saveStamp = false

#internal variables
var stampData = {}

func _ready():
	pass

func _process(delta):
	pass
	if saveStamp:
		saveStamp()
		saveStamp = !saveStamp

func saveStamp():
	print("saving stamp")
	var pKey = []
	var sKey = []
	var pattern = $Pattern
	var stamp = $Stamp
	
	for pos in pattern.get_used_cells():
		pKey.append([int(pos.x),int(pos.y),pattern.get_cellv(pos)])
	for pos in stamp.get_used_cells():
		sKey.append([int(pos.x),int(pos.y),stamp.get_cellv(pos)])
	
	stampData = {
		name = stampName,
		pattern_key = pKey,
		stamp_key = sKey,
		prob = [Probability.x,Probability.y],
		limit = limitSpawns,
		rotate = rotation
		}
	print("storing stamp data")
	
	writeToFile()

func writeToFile():
	var library = {}
	var file = File.new()
	
	#check if the library already exists
	if file.file_exists(StampLibraryPath):
		print("existing library found, loading...")
		file.open(StampLibraryPath, file.READ)
		library = parse_json(file.get_as_text())
		file.close()
	
	file.open(StampLibraryPath, file.WRITE)
	library[stampName] = stampData
	file.store_string(to_json(library))
	file.close()
	print("stamp saved")
	