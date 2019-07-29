extends Node

var _last_pos = Vector2(0,0)
var _last_successful_pos = Vector2(0,0)

var stamp_library = []

func _init():
	stamp_library = process_stamps(get_stamp_paths())

func process_stamps(imgs):
	var library = []
	for img_path in imgs:
		var img = load(img_path).get_data()
		img.convert(Image.FORMAT_RGBA8)
		img.lock();var tag = img.get_pixel(0,img.get_height()-1);img.unlock()
#		print(img_path)
		
		#organize stamps into groups based on color tags in bottom left corner
		var group_found = false
		for group in library:
			if group[0].tag == tag:
				group.append(Stamp.new(img))
				group_found = true
		
		#if a color group doesn't already exist, make a new one
		if not group_found:
			library.append([Stamp.new(img)])
			
	return library

func get_stamp_paths(path="res://src/stamps/"):
	var dir = Directory.new()
	var stamps = []
	var directories = []
	dir.open(path)
	dir.list_dir_begin()

	# Get every file in directory
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			if dir.current_is_dir():
				directories.append(file)
			else:
				if file.ends_with(".png"):
					stamps.append(path + file)
	#go through directories
	for d in directories:
		stamps = stamps + get_stamp_paths(path + d + "/")
	
	dir.list_dir_end()
	return stamps

func get_stamps_by_tag(tag=Color(1,1,1,1)):
	for group in stamp_library:
		if group[0].tag == tag:
			return group
	return stamp_library[0]

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
	
