extends Node2D

export(float) var spawnPerSecond = 0
export(int) var loopsPerUpdate = 1
export(int) var spawnSeed = 11111
export(bool) var randomSeed = false
export(NodePath) var seedLabel

# stamp libraries
var library1Name = ""
var library2Name = ""
var library3Name = ""
var library1:Array
var library2:Array
var library3:Array

# Tile match generators
var stage1Matcher: TileMatcher
var stage2Matcher: TileMatcher
var stage3Matcher: TileMatcher

#internal variables
var tilemap:TileMap
var stage : int = 0
var clock:float = 0
var done: bool = false

func _ready():
	# get tilemap object
	if randomSeed:
		randomize();
		spawnSeed = randi() % 99999
	
	#set the ui to show current seed
	get_node(seedLabel).text = str(spawnSeed)
	seed(spawnSeed)
	
	# load libraries
	library1 = EB.stampLibraries[library1Name]
	library2 = EB.stampLibraries[library2Name]
	library3 = EB.stampLibraries[library3Name]
	
	stage1Matcher = TileMatcher.new(tilemap,library1)
	stage2Matcher = TileMatcher.new(tilemap,library2)
	stage3Matcher = TileMatcher.new(tilemap,library3)

func _process(delta):
	var matcher = stage1Matcher
	
	clock += delta
	if clock > spawnPerSecond and not done:

		var i = 0
		while i < loopsPerUpdate:
			var genCheck = matcher.generate()
			if genCheck[0].size.y > 50:#not genCheck[2]:
				done = true
				print("Done yeeting")
				
			clock = 0
			i += 1
	
	#enter to  reload scene and regenerate
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()

