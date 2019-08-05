extends Node2D

# x = index % size
# y = index / size
# index = y * size + x

var library = Stamps.stampLibraries["dungeon1.start"]
var Lvl = preload("res://src/Lvl.gd")
var lvl
var clock = 0.0
var gen

func _ready():
	randomize()
	lvl = Lvl.new(library, 50)
	gen = lvl.tileMatch(library)
	layoutToTilemap(lvl.getLayout(), 50)

func _process(delta):
	clock += delta
	if clock > 0.001:
		clock = 0.0
	
#	if not lvl.finishedGenerating:
#		gen = gen.resume()
#		layoutToTilemap(lvl.getLayout(), 50)

func layoutToTilemap(layout, size):
	for i in range(layout.size()):
		$TileMap.set_cell(i%size, i/size, layout[i])


