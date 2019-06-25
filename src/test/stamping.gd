extends Node2D



func _ready():
	var pattern = Image.new()
	pattern.load("res://src/test/test_art/test_pattern1.png")
	
	var stamp = Image.new()
	stamp.load("res://src/test/test_art/stamp_1.png")
	
	try_stamp(pattern, stamp)

func try_stamp(pattern, stamp, start=[0,0]):
	var cutout = pattern.get_rect( Rect2(start[0],start[1], stamp.get_width(), stamp.get_height()))
	
	var px = 0
	var py = 0
	var width = stamp.get_width()
	var height = stamp.get_height()
	var maskRect = Rect2(1,1,width-2,height-2)
	
	while py < height:
		while px < width:
			
			if maskRect.has_point(Vector2(px,py)):
				print(px)
				px+= 1
				break
			
			#print(px)
			pattern.lock()
			pattern.set_pixel(px,py, Color(1,0,0,1))
			pattern.unlock()
			#iterate through x axis
			px += 1
		
		#reset x axis iterator and iterate on y axis
		px = 0
		py += 1
	
	var tex = ImageTexture.new()
	tex.create_from_image(pattern)
	tex.set_flags(2)
	$pattern.set_texture(tex)
	
	
	