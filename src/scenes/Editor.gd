extends Node2D

# x = index % size
# y = index / size
# index = y * size + x

var size = 50
var testlayout = []
var layout = []
var clock = 0.0

func _ready():
	for i in range(0,size*size):
		#layout.append(randi()%2-1)
		layout.append(-1)
		testlayout.append(i)
	
#	print(Stamps.stampLibraries["dungeon1.start"]["start"])
	layoutToTilemap()

func _process(delta):
	#for now just loop through all the stamp libraries
	var library = Stamps.stampLibraries["dungeon1.start"]
	clock += delta
	if clock < 1000:
		clock = 0.0
#		print ("tick")
		tileMatch(library)
		layoutToTilemap()

func placeStamp(x, y, stamp, stampSize):
	#printStamp(stamp, size)
	for i in range(stamp.size()):
		var stampx = x + i%stampSize
		var stampy = y + i/stampSize
		layout[ stampy*size + stampx] = stamp[i]
#		print(" i" + str( size * (y + i/size) + (x + i%size )) + " =>" + str(stamp[i]))
#		print(stampSize)
#	printStamp(layout,size)

func layoutToTilemap():
	for i in range(layout.size()):
		$TileMap.set_cell(i%size, i/size, layout[i])

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
		

func tileMatch(library):
	#it's faster to loop through the layout once and 
	#then loop through each stamp instead of the other way around
	for i in range(size*size):
		var stageUnlock = library.size()
		for stampName in library:
			var stamp = library[stampName]
			var pattern = stamp["pattern"]
			var unlock = pattern.size()
			var stampSize = int(stamp["size"])
			
			var x = 0
			var y = 0
			
			#loop through stamp pattern, reuse unlock because it is size of pattern
			for j in range(unlock):
				# combine xy coords for stamp and pos in layout
				x = i%size + j%stampSize
				y = i/size + j/stampSize
				if x < size and y < size:
					if layout[x + y * size] == pattern[j]: #compare tiles with pattern to match
						unlock -= 1
						#unlock keeps track of number of matched tiles
					else:
						unlock = pattern.size()
			if unlock <= 0:
#				print("---------------------placing "+ stampName +" x" + str(i%size) + ":y" + str(i/size))
				placeStamp(int(i%size), int(i/size), stamp["stamp"], stampSize)
				stageUnlock -= 1
#			print("---------------------checking "+ stampName +" x" + str(x) + ":y" + str(x))
		
		if stageUnlock < library.size():
			i = 0
			#if one has stamped, keep going
#	print("#######done#######")

func stampMatch(stamp):
	#it's faster to loop through the layout once and 
	#then loop through each stamp instead of the other way around
	for i in range(size*size):
		var pattern = stamp["pattern"]
		var unlock = pattern.size()
		var stampSize = int(stamp["size"])
		
		var x = 0
		var y = 0
		
		#loop through stamp pattern, reuse unlock because it is size of pattern
		for j in range(unlock):
			# combine xy coords for stamp and pos in layout
			x = i%size + j%stampSize
			y = i/size + j/stampSize
			if x < size and y < size:
				if layout[x + y * size] == pattern[j]: #compare tiles with pattern to match
					unlock -= 1
					#unlock keeps track of number of matched tiles
				else:
					unlock = pattern.size()
		if unlock <= 0:
			print("---------------------placing "+ "Start" +" x" + str(i%size) + ":y" + str(i/size))
			placeStamp(int(i%size), int(i/size), stamp["stamp"], stampSize)
			
#		print("---------------------checking "+ "start" +" x" + str(i%size) + ":y" + str(i/size))
		

