extends Node

func _ready():
	pass # Replace with function body.

class Pattern:
	var _template: Image
	var _img: Image = Image.new()
	var _seed: int = randi()
	var _stage: int = 0
	var _mask: Rect2
	var _stamps = {}
	var _clock: float = 0.0
	
	func _init(img, tag=Color(1,1,1,1), mask=null):
		#Saving original template and a copy
		_template = img
		_img.copy_from(img)
		
		#make a mask based on img if mask is not supplied
		if mask == null:_mask = Rect2(0,0, img.get_width(), img.get_height());else:_mask = mask
		
		#get and organize stamps for pattern
		var stamp_group: Array
		for group in Stamps.stamp_library:
			if group[0].tag == tag:
				stamp_group = group
		#optimize them into stages
		for stamp in stamp_group:
			if _stamps.has(stamp._stage):
				_stamps[stamp._stage].append(stamp)
			else:
				_stamps[stamp._stage] = [stamp]
#		print(_stamps[0])
	
	func gen_step(delta):
		if _stamps.has(_stage):
			for stamp in _stamps[_stage]:
				if stamp.activate(_img, _seed, _stage):
						_clock = 0.0
#			print(_clock)
			if _clock > 4:
				_stage += 1
				_clock = 0.0
				print("stage: "+str(_stage))
		_clock += delta
	
	func get_texture():
		var tex = ImageTexture.new(); tex.create_from_image(_img, 2)
		return tex
		
	func get_image():
		var img = Image.new();img.copy_from(_img)
		return img
	
	