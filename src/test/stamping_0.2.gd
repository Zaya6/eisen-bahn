extends Node

#var pattern_img = "res://src/test/test_art/test_pattern1.png"
#var stamp_imgs = [
#	"res://src/test/test_art/stamp_3.png",
#	"res://src/test/test_art/stamp_4.png",
#	"res://src/test/test_art/stamp_5.png",
#	"res://src/test/test_art/stamp_6.png"
#]
export(Image) var pattern 
export(Array, Image) var stamp_imgs 
export(Array, int) var mods

var clock = 0.0
var stamps = []

class Stamp:
	var key = []
	var img = null
	var width = 0
	var height = 0
	var rect = null
	var activations = -1
	
	func _init(nimg, nkey, nact=100):
		img = nimg
		key = nkey
		activations = nact
		width = nimg.get_width()
		height = nimg.get_height()
		rect = Rect2(0,0,width,height)
	
	func activate(pttrn, position):
		print(activations)
		if activations > 0:
			activations -= 1
		if activations != 0:
			img.lock()
			pttrn.lock()
			pttrn.blend_rect(img, Rect2(0,0,width, height), position) 
			img.unlock()
			pttrn.unlock()
		return pttrn
		
	func lock():
		img.lock()
	func unlock():
		img.unlock()
		

func _ready():
	set_process(true) #enable game loop
	randomize()
	
	#we only care about the keys
	var i = 0
	for img in stamp_imgs:
		stamps.append( Stamp.new( img, _get_stamp_keys(img), mods[i] ) )
		i += 1
#		print(mods[i-1])

func _process(delta):
#	clock += delta
#	if clock > 1:
#		clock = 0.0
#		var i = randi() % stamps.size()
#		print( "trying " + str(i+1) )
#
#		try_stamp( stamps[ i ] )
	var i = randi() % stamps.size()
#	print( "trying " + str(i+1) )
	print(i)
	try_stamp( stamps[ i ] )

func _get_stamp_keys(stamp):
	var key_pixels = []
	var px = 0
	var py = 0
	var width = stamp.get_width()
	var height = stamp.get_height()
	var maskRect = Rect2( 1, 1, width-2, height-2 )
	stamp.lock()
	while py < height:
		while px < width:
			#only compare edges
			if not maskRect.has_point( Vector2( px, py )):
				#discard transparent pixels
				var pixel = stamp.get_pixel(px, py)
				if pixel.a != 0:
					key_pixels.append( [ Vector2( px, py ), pixel ] )
			px += 1
		px = 0
		py += 1
	stamp.unlock()
#	print(key_pixels)
	return key_pixels

#right now it only stamps horizontally but...
#here would be to make the change to match on y too
func try_stamp(stamp):
	var die = randi() % 4
	var cut_pos
	
	if die == 0:
		# from left top side
		cut_pos = Vector2(randi() % pattern.get_width(), randi() % pattern.get_height())
		while cut_pos.y < pattern.get_height():
			while cut_pos.x < pattern.get_width():
				var cutout = pattern.get_rect( Rect2(cut_pos.x,cut_pos.y, stamp.img.get_width(), stamp.img.get_height()))
				if compare_cutout(pattern, cutout, stamp.key, cut_pos): 
#					print("match")
					stamp.activate(pattern, cut_pos)
					var tex = ImageTexture.new()
					tex.create_from_image(pattern, 2)
					$pattern.set_texture(tex)
					return true
				cut_pos.x += 1
	
			cut_pos.x = 0
			cut_pos.y += 1
	elif die == 1:
		#from right bottom side
		cut_pos = Vector2(randi() % pattern.get_width(), randi() % pattern.get_height())
		while cut_pos.y > 0:
			while cut_pos.x > 0:
				var cutout = pattern.get_rect( Rect2(cut_pos.x,cut_pos.y, stamp.img.get_width(), stamp.img.get_height()))
				if compare_cutout(pattern, cutout, stamp.key, cut_pos): 
#					print("match")
					stamp.activate(pattern, cut_pos)
					var tex = ImageTexture.new()
					tex.create_from_image(pattern, 2)
					$pattern.set_texture(tex)
					return true
				cut_pos.x -= 1
	
			cut_pos.x = pattern.get_width()-1
			cut_pos.y -= 1
	elif die == 2:
		#from top left down
		cut_pos = Vector2(randi() % pattern.get_width(), randi() % pattern.get_height())
		while cut_pos.x < pattern.get_height():
			while cut_pos.y < pattern.get_width():
				var cutout = pattern.get_rect( Rect2(cut_pos.x,cut_pos.y, stamp.img.get_width(), stamp.img.get_height()))
				if compare_cutout(pattern, cutout, stamp.key, cut_pos): 
#					print("match")
					stamp.activate(pattern, cut_pos)
					var tex = ImageTexture.new()
					tex.create_from_image(pattern, 2)
					$pattern.set_texture(tex)
					return true
				cut_pos.y += 1
	
			cut_pos.y = 0
			cut_pos.x += 1
	elif die == 3:
		#from bottom right up
		cut_pos = Vector2(randi() % pattern.get_width(), randi() % pattern.get_height())
		while cut_pos.x > 0:
			while cut_pos.y > 0:
				var cutout = pattern.get_rect( Rect2(cut_pos.x,cut_pos.y, stamp.img.get_width(), stamp.img.get_height()))
				if compare_cutout(pattern, cutout, stamp.key, cut_pos): 
#					print("match")
					stamp.activate(pattern, cut_pos)
					var tex = ImageTexture.new()
					tex.create_from_image(pattern, 2)
					$pattern.set_texture(tex)
					return true
				cut_pos.y -= 1
	
			cut_pos.y = pattern.get_width()-1
			cut_pos.x -= 1
	
	return false

func compare_cutout(pattern, cutout, key_pixels, start):
	var lock = key_pixels.size()
	
	cutout.lock()
	for key in key_pixels:
		var cpixel = cutout.get_pixel(key[0].x, key[0].y)
		if cpixel.a != 0:
			if cpixel == key[1]:
				lock -= 1
		else:
			return false
	cutout.unlock()
	
	if lock == 0:
		return true
	else:
		return false

