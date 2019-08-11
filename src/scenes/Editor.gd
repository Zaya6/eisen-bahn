extends Node2D

# x = index % size
# y = index / size
# index = y * size + x

var library
var Lvl = preload("res://src/Lvl.gd")
var lvl
var clock = 0.0
var gen
var width = 20
var height = 100

func _ready():
	randomize()
	library = Stamps.stampLibraries["traincar.start"]
	lvl = Lvl.new(library, width, height, 0)
	gen = lvl.tileMatch(library)
	layoutToTilemap(lvl.getLayout(), width, height)

func _process(delta):
	clock += delta
	if clock > 0.001:
		clock = 0.0
	
	if not lvl.finishedGenerating:
		layoutToTilemap(lvl.getLayout(), width, height)
		gen = gen.resume()
		

func layoutToTilemap(layout, w, h):
	for i in range(w*h):
		$TileMap.set_cell(i%w, i/h, layout[i])


