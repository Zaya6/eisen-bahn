extends TileMap

var sizeX:int = 10
var sizeY:int = 10
var defaultTile:int = -1
var layout:PoolIntArray = PoolIntArray()
var library:Dictionary
var finishedGenerating = false


func _init():
	
	#fill the layout array with default tile values
	for i in range(sizeX*sizeY):
		layout.append(defaultTile)

#func generate():
#	tileMatch(library)
#	return layout

