extends Node2D


func _ready():
	set_process(true)
	$"../guide".set_texture(draw_frame(100, 100))
#	var pattern = $"/root/TrainGen".make_train_pattern()
#	$"../guide".texture = pattern.get_texture()
	
	pass

#func _process(delta):
#	if Input.is_action_just_pressed("ui_accept"):
#		var pattern = $"/root/TrainGen".make_train_pattern()
#		$"../guide".texture = pattern.get_texture()


func draw_frame(width=256, height=256):
	var img = Image.new()
	img.create(width, height, false, Image.FORMAT_RGB8)
	
	var px = 0
	var py = 0
	var mask = Rect2( 1,1,width-2,height-2)
	img.lock()
	
	while py < height:
		while px < width:
			if not mask.has_point(Vector2(px, py)):
				img.set_pixel(px, py, Color(0.5,0.8,0.5,0))
			px += 1
		px = 0
		py+=1
	
	img.unlock()
	
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	tex.set_flags(2)
	return tex
	