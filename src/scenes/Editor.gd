extends Node2D

# x = index % size
# y = index / size
# index = y * size + x

var size = 24
var testlayout = []
var layout = []

func _ready():
	for i in range(0,size*size):
		#layout.append(randi()%2-1)
		layout.append(0)
		testlayout.append(i)
	
	Stamps.loadStampLibrary()
	layoutToTilemap()

func _process(delta):
	return
#	for i in range(layout.size()):
#		var unlock = stamp1[0].size()
#		var x = 0
#		var y = 0
#		#loop through stamp pattern
#		for j in range(stamp1[0].size()):
#			# combine xy coords for stamp and pos in layout
#			x = i%size + j%stamp1[2]
#			y = i/size + j/stamp1[2]
#			if x < size and y < size:
#				if layout[x + y * size] == stamp1[0][j]:
#					unlock -= 1
#		if unlock <= 0:
#			placeStamp(x, y, stamp1)
		

func placeStamp(x, y, stamp):
	print(stamp[1])
	for i in stamp[1]:
#		print(x + i%stamp[2])
		$TileMap.set_cell(x + i%stamp[2], y + i/stamp[2], i)

func layoutToTilemap():
	for i in range(layout.size()):
		$TileMap.set_cell(i%size, i/size, layout[i])
