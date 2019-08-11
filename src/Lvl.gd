extends Node

# x = index % size
# y = index / size
# index = y * size + x

var sizeX:int = 0
var sizeY:int = 0
var layout:PoolIntArray = PoolIntArray()
var library:Dictionary
var finishedGenerating = false

func _init(nlibrary:Dictionary, nsizeX:int=20, nsizeY:int=20, defaultTileValue:int=-1):
	sizeX = nsizeX
	sizeY = nsizeY
	library = nlibrary
	
	#fill the layout array with default tile values
	for i in range(sizeX*sizeY):
		layout.append(defaultTileValue)

func generate():
	tileMatch(library)
	return layout

#it's faster to loop through the layout once and 
#then loop through each stamp instead of the other way around
func tileMatch(library):
	var pos
	var stageUnlock
	var stamp 
	var pattern
	var unlock
	var stampSizeX
	var stampSizeY
	var checkPos
	var matchSucess
	
	var i = 0
	var matchFound = false
	var coverCheck = sizeX*sizeY
	while i < sizeX*sizeY:
		pos = indexToXY(i)
		
		for stampName in library:
			stamp = library[stampName]
			
			#check first if it succeeds
			if rand_range(0,1) > float(stamp["matchSuccess"]): continue
			pattern = stamp["pattern"]
			unlock = pattern.size()
			stampSizeX = int(stamp["sizeX"])
			stampSizeY = int(stamp["sizeY"])
			checkPos = Vect.new()
			
			#loop through stamp pattern, reuse unlock because it is size of pattern
			for j in range(unlock):
				checkPos.x = pos.x + j%stampSizeX
				checkPos.y = pos.y + j/stampSizeY
				if checkPos.x < sizeX and checkPos.y < sizeY:
					if getTile(checkPos.x,checkPos.y) == pattern[j]: #compare tiles with pattern to match
						unlock -= 1 #unlock keeps track of number of matched tiles
					else:
						break
			if unlock <= 0:
				placeStamp(pos.x, pos.y, stamp["stamp"], stampSizeX, stampSizeX )
				coverCheck -= 2
				matchFound = true
			yield()
		i += 1
		if i >= sizeX*sizeY:
			if matchFound or coverCheck > sizeX*sizeY*0.2:
				print(str(coverCheck) + ":" + str(sizeX*sizeY*0.2))
				matchFound = false
				i = 0
			else:
				break
	finishedGenerating = true
	print("done")

func placeStamp(x, y, stamp, stampSizeX, stampSizeY ):
	# in order to place it correctly we must combine the xy give
	# with the xy of the stamp and then turn it back int an index
	# to place it within the layout
	for i in range(stamp.size()):
		setTile(x + i%stampSizeX, y + i/stampSizeY, stamp[i])

func printStamp(stamp, size):
	var y = 0
	while y < size:
		var row = ""
		for x in range(size):
			var i = size*y+x
			var stmp = str(stamp[i])
			var sp = "   "
			sp.erase(0, stmp.length()-1)
			row += sp + stmp
		y += 1
		print(row)

func setTile(x:int, y:int, tile:int):
	layout[ y * sizeX + x] = tile

func getTile(x:int, y:int):
	return layout[ y * sizeX + x]

func indexToXY(i):
	return Vect.new(i%sizeX,i/sizeY)

func getLayout():
	return layout

class Vect:
	var x:int = 0
	var y:int = 0
	func _init(nx:int=0,ny:int=0):
		x = nx
		y = ny