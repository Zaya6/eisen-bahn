extends Node2D

var pattern = Image.new()
var stamp = Image.new()

func _ready():
	set_process(true)
	
	pattern.load("res://src/test/test_art/test_pattern1.png")
	
	stamp.load("res://src/test/test_art/stamp_1.png")
	

var cut_pos = Vector2(0,0)
func _process(delta):
	
	if cut_pos.y < pattern.get_height():
		if cut_pos.x < pattern.get_width():
			try_stamp(cut_pos)
			cut_pos.x += 1
		else:
			cut_pos.x = 0
			cut_pos.y += 1
	

func try_stamp(start=Vector2(0,0)):
	var cutout = pattern.get_rect( Rect2(start.x,start.y, stamp.get_width(), stamp.get_height()))
	
	var px = 0
	var py = 0
	var width = stamp.get_width()
	var height = stamp.get_height()
	var maskRect = Rect2(1,1,width-2,height-2)
	
	pattern.lock()
	while py < height:
		while px < width:
			
			if not maskRect.has_point(Vector2(px,py)):
				pattern.set_pixel(start.x + px,start.y + py, Color(1,0,0,1))
			#iterate through x axis
			px += 1
		
		#reset x axis iterator and iterate on y axis
		px = 0
		py += 1
	pattern.unlock()
	var tex = ImageTexture.new()
	tex.create_from_image(pattern)
	tex.set_flags(2)
	$pattern.set_texture(tex)
	
	
	