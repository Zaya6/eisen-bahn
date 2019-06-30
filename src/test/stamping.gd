extends Node2D

var patterni = null
var stampi = null
var key_pixelsi = []
var cut_posi = Vector2(0,0)

func _ready():
	set_process(true)
	
	var pattern = Image.new()
	var stamp = Image.new()
	pattern.load("res://src/test/test_art/test_pattern1.png")
	stamp.load("res://src/test/test_art/stamp_1.png")
	patterni = pattern
	stampi = stamp
	
#	try_stamp(pattern,stamp)
	key_pixelsi = try_stamp_return(pattern,stamp)
	


func _process(delta):
	cutout_step_loop(patterni, stampi, key_pixelsi)
	pass
	
	

func try_stamp(pattern, stamp):
	var key_pixels = []
	var px = 0
	var py = 0
	var maskRect = Rect2(1,1,stamp.get_width()-2,stamp.get_height()-2)
	stamp.lock()
	while py < stamp.get_height():
		while px < stamp.get_width():
			#only compare edges
			if not maskRect.has_point(Vector2(px,py)):
				#only compare non transparent pixels
				var pixel = stamp.get_pixel(px, py)
				if pixel.a != 0:
					key_pixels.append( [ Vector2( px, py ), pixel ] )
			px += 1
		px = 0
		py += 1
	stamp.unlock()
	print(key_pixels)
	cutout_loop(pattern, stamp, key_pixels)
	
func try_stamp_return(pattern, stamp):
	var key_pixels = []
	var px = 0
	var py = 0
	var maskRect = Rect2(1,1,stamp.get_width()-2,stamp.get_height()-2)
	stamp.lock()
	while py < stamp.get_height():
		while px < stamp.get_width():
			#only compare edges
			if not maskRect.has_point(Vector2(px,py)):
				#only compare non transparent pixels
				var pixel = stamp.get_pixel(px, py)
				if pixel.a != 0:
					key_pixels.append( [ Vector2( px, py ), pixel ] )
			px += 1
		px = 0
		py += 1
	stamp.unlock()
	return key_pixels
	
func cutout_loop(pattern, stamp, key_pixels):
	var cut_pos = Vector2(0,0)
	while cut_pos.y < pattern.get_height():
		while cut_pos.x < pattern.get_width():
			var cutout = pattern.get_rect( Rect2(cut_pos.x,cut_pos.y, stamp.get_width(), stamp.get_height()))
			compare_cutout(pattern, cutout, key_pixels, cut_pos)
			cut_pos.x += 1

		cut_pos.x = 0
		cut_pos.y += 1

#func cutout_step_loop(pattern, stamp, key_pixels):
#	if cut_posi.y < pattern.get_height():
#		if cut_posi.x < pattern.get_width():
#			var cutout = pattern.get_rect( Rect2(cut_posi.x,cut_posi.y, stamp.get_width(), stamp.get_height()))
#			compare_cutout(pattern, cutout, key_pixels, cut_posi)
#			$stamp.set_position(cut_posi - Vector2(pattern.get_width()/2,pattern.get_height()/2 ) + Vector2(stamp.get_width()/2,stamp.get_height()/2 ))
#			cut_posi.x += 1
#		else:
#			cut_posi.x = 0
#			cut_posi.y += 1

func compare_cutout(pattern, cutout, key_pixels, start):
	var lock = key_pixels.size()
	
	cutout.lock()
	for key in key_pixels:
		if cutout.get_pixel(key[0].x, key[0].y) == key[1]:
			lock -= 1
	cutout.unlock()
	
	#if a match is found
	pattern.lock()
	if lock == 0:
		print("match")
		#draw matched pixels green
		for key in key_pixels:
			pattern.set_pixel( start.x+key[0].x, start.y+key[0].y, Color(0,1,0,1) )
		
		var tex = ImageTexture.new()
		tex.create_from_image(pattern)
		tex.set_flags(2)
		$pattern.set_texture(tex)
		pattern.unlock()
		return true
	return false
	
	
	