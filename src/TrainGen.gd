extends Node

var sd = randi()


		
func make_train_pattern():
	var pattern = Pattern.new(16, 16 + randi() % 30)
	
	try_stamp(pattern, Stamps.train_basic[0])
	
	print(Color(1,1,1,1) - Color(1,0,0,0))
		
	return pattern

#TODO: start a basic stamping system
#Maybe it pulls a rect the size of the stamp and compares them by subtracting color
#Must keep stamp within pattern boounds
func try_stamp(pattern, stamp):
	var st = Image.new()
	st.load(stamp.location)
	pattern.raw = st
	pass

class Pattern:
	var width = 0
	var height = 0
	var raw
	
	func _init(nwidth, nheight):
		width = nwidth
		height = nheight
		
		raw = Image.new()
		raw.create(width,height, false, Image.FORMAT_RGBA8)
		raw.fill(Color(1,1,1,1))
	
	func try_stamp(stamp):
		pass
		
	func get_texture():
		var tex = ImageTexture.new()
		tex.create_from_image(raw)
		tex.flags = 2
		return tex