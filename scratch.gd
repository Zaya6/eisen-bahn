#Tile matching

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


#pixel matching

class Stamp:
	var _key = []
	var _base: Image
	var _pttrn: Rect2
	var _stamp: Rect2
	var _success_rate: float
	var _last_seed: int
	var _last_pos = null
	var _activations: int = 0
	var _activate_limit: int = 0
	var _stage: int = 0
	var _method: int = 255
	var tag = Color(1,1,1,1)
	var tile_width: int = 0
	var tile_height: int = 0
	var growth_type: int = 0
	var _debug
	
	func _init(base):
		base.convert(Image.FORMAT_RGBA8)
		_base = base
		var base_width = base.get_width()
		var base_height = base.get_height()
		
		#lock base image for manipulation and get border for pattern and stamp shape
		base.lock()
		var border= find_border(base, 1,0) + find_border(base, 0,1)
#		print(border)
		#find sections of base image and make rects
		_pttrn = Rect2(Vector2(0,0), border)
		_stamp = Rect2(border.x + 1, 0, base_width - border.x - 1, base_height - 2)

		#get key from pattern
		var px = 0; var py = 0
		while py < _pttrn.size.y:
			while px < _pttrn.size.x:
				var pixel = base.get_pixel(px,py)
				if pixel.a != 0:
					_key.append([Vector2(px,py), pixel])
				px += 1
			px = 0
			py += 1

		# get properties
		_activate_limit = int(base.get_pixel(1,base_height-1).r * 255)
		_success_rate = base.get_pixel(1,base_height-1).g
		_stage = int(base.get_pixel(1,base_height-1).b * 255)
		_method = int(base.get_pixel(1,base_height-1).a * 255)
#		print(_method)
		tag = base.get_pixel(0,base_height-1)
		
		base.unlock()
	
	func find_border(base, stepx, stepy):
		var pos = Vector2(0,0)  
		var rect = Rect2(0,0, base.get_width()-1 , base.get_height()-1)
		while rect.has_point(pos):
			var pixel = base.get_pixelv(pos)
			if pixel == Color(1,0,1,1):
				return pos
			else:
				pos += Vector2(stepx,stepy)

		return Vector2(0,0)
	
	func activate(map, nseed=0, stage=0):
		#fail immediate if stage is wrong
		if _stage != stage:
			return false
			
		#fail immediately if fails success rate check
		if rand_range(0.0,1.0) > _success_rate:
			return false
			
		#reset activations if new map seed is passed
		if nseed != _last_seed:
			_last_seed = nseed
			_activations = 0
			_last_pos = Vector2(randi() % map.get_width(), randi() % map.get_height())
		
		#do activation limits or not
		if _activate_limit > 0:
			if _activations <= _activate_limit:
				if use_method(map):
					_activations += 1
					return true
				else:
					return false
		else:
			return use_method(map)
		
		return false
	
	func use_method(map):
#		print(_method)
		var map_width = map.get_width(); var map_height = map.get_height()
		var ranPos = Vector2(randi() % map_width, randi() % map_height)
		if _method == 255:
			return pixel_match(map, ranPos)
		elif _method == 254:
			return pixel_match(map, Stamps._last_pos + ranPos * 0.1)
		elif _method == 253:
			return pixel_match(map, Stamps._last_successful_pos)
			if pixel_match(map, Stamps._last_successful_pos):
				Stamps._last_successful_pos = ranPos
				return true
			else:
				return false
	
	func pixel_match(map, pos):
		Stamps._last_pos = pos
		var stepx = 0; if randi()%3 <= 2: stepx = -1;elif randi()%2 <= 1: stepx = 1;
		var stepy = 0; if randi()%3 <= 2: stepy = -1;elif randi()%2 <= 1: stepx = 1;elif not stepx: stepx = 1
		var map_width = map.get_width(); var map_height = map.get_height()
		var map_rect = Rect2(0,0, map_width, map_height)
		
		map.lock()
		while map_rect.has_point(pos):
			var padlock = _key.size()
			for k in _key:
				var key_pos = pos + k[0]
				if map_rect.has_point(key_pos):
					var pixel = map.get_pixelv(key_pos)
					if pixel.a != 0 and pixel == k[1]:
						padlock -= 1
					
			if padlock == 0: #if padlock is 0 then MATCH!
				map.blend_rect(_base, _stamp, pos)
				map.unlock()
				Stamps._last_successful_pos = pos
				return true
			pos += Vector2(stepx, stepy)
			
		map.unlock()
		return false
		
	func get_stamp_img():
		var img = Image.new()
		img.create(_stamp.size.x, _stamp.size.y, false, Image.FORMAT_RGBA8)
		img.blit_rect(_base, _stamp, Vector2(0,0))
		return img
		
	func get_pattern_img():
		var img = Image.new()
		img.create(_stamp.size.x, _stamp.size.y, false, Image.FORMAT_RGBA8)
		img.blit_rect(_base, _pttrn, Vector2(0,0))
		return img
	