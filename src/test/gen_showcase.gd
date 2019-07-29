extends Node

var pattern

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	Stamps._init()
	
	pattern = Patterns.Pattern.new(load("res://src/patterns/dungeon_v2.png").get_data(), Color(1,0,0,1))

	set_map_view(pattern.get_texture())
	
	print("stage: 0")


func _process(delta):
	pattern.gen_step(delta)
	set_map_view(pattern.get_texture())
	set_tiles(pattern.get_image())
	
func set_map_view(tex):
	$CanvasLayer/cont/map.set_texture(tex)

func set_tiles(img):
	img.lock()
	var width = img.get_width()
	var height = img.get_height()
	for y in range(height):
		for x in range(width):
			if img.get_pixel(x,y) == Color(1,1,1):
				$TileMap.set_cell(x-width/2, y-height/2,1)
			else:
				$TileMap.set_cell(x-width/2, y-height/2,0)
			