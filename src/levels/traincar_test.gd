extends Node2D

export(float) var spawnPerSecond = 0
export(int) var loopsPerUpdate = 1
export(int) var spawnSeed = 11111
export(bool) var randomSeed = false
export(NodePath) var seedLabel

# stamp libraries and matchers
var libraryNames = ["train_test","train_test","train_test"]
var library1 : Array
var library2 : Array
var library3 : Array
var stageMatcher1:TileMatcher
var stageMatcher2:TileMatcher
var stageMatcher3:TileMatcher


#internal variables
var tilemap:TileMap
var stage : int = 0
var clock:float = 0
var done: bool = false
var currentMatcher: TileMatcher

func _ready():
	#set tilemap 
	tilemap = $TileMap
	
	# get tilemap object
	if randomSeed:
		randomize();
		spawnSeed = randi() % 99999
	
	#set the ui to show current seed
	get_node(seedLabel).text = str(spawnSeed)
	seed(spawnSeed)
	
	# load libraries
	library1 = EB.stampLibraries[libraryNames[0]]
	library2 = EB.stampLibraries[libraryNames[1]]
	library3 = EB.stampLibraries[libraryNames[2]]
	
	#set up tile match generators
	stageMatcher1 = TileMatcher.new(tilemap,library1)
	stageMatcher2 = TileMatcher.new(tilemap,library2)
	stageMatcher3 = TileMatcher.new(tilemap,library3)
#	print(TileMatcher.new(tilemap,libraries[0]))

func _process(delta):
	var matcher = stageMatcher1
	print(matcher)
	
	clock += delta
	if clock > spawnPerSecond and not done:

		var i = 0
		while i < loopsPerUpdate:
			#gencheck stores array with data on generation
			var genCheck = matcher.generate()

			if genCheck[0].size.y > 50 and not genCheck[2]:
				stage += 1
				if stage > 0: #end on specific stage
					done = true
					print("Done yeeting")

			clock = 0
			i += 1
	
	#enter to  reload scene and regenerate
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()

