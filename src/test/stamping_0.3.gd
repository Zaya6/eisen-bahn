extends Node

export(Array, Image) var stamp_paths
var stamps = []
var stage = 0
var gen_total = 100.0
var fails = 0.0
var map

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	randomize()
	
	# get base map pattern
	map = Image.new(); map.load("res://src/test/test_art/test_pattern3.png")
	
	#get stamps
	for img in stamp_paths:
		stamps.append(Stamps.Stamp.new(img))

var clock = 0.0
func _process(delta):
	clock += delta
	if stage < 10:
		var stage_stamps = get_stage_stamps()
		for stamp in stage_stamps:
			if stamp.activate(map, 0, stage):
				clock = 0.0
		print(clock)
		if clock > 4:
			print("new stage")
			stage += 1
			clock = 0.0

	set_pattern(map)

func set_pattern(img):
	var tex = ImageTexture.new(); tex.create_from_image(img, 2)
	$pattern.set_texture(tex)
	
func get_stage_stamps():
	var stage_stamps = []
	for stamp in stamps:
		if stamp._stage == stage:
			stage_stamps.append(stamp)
	return stage_stamps