extends Node2D

export(float) var spawnPerSecond = 0
export(int) var loopsPerUpdate = 1
export(int) var spawnSeed = 11111
export(bool) var randomSeed = false
export(NodePath) var seedLabel

# stamp libraries and matchers
var libraryNames = ["train_test","train_test","train_test"]
var libraries:Array
var stageMatchers: Array 


#internal variables
var tilemap:TileMap
var stage : int = 0
var clock:float = 0
var done: bool = false
var currentMatcher: TileMatcher

func _ready():
	# get tilemap object
	if randomSeed:
		randomize();
		spawnSeed = randi() % 99999
	
	#set the ui to show current seed
	get_node(seedLabel).text = str(spawnSeed)
	seed(spawnSeed)
	
	# load libraries
	libraries.push_back( EB.stampLibraries[libraryNames[0]])
	libraries.push_back( EB.stampLibraries[libraryNames[1]])
	libraries.push_back( EB.stampLibraries[libraryNames[2]])
	
	#set up tile match generators
	stageMatchers.push_back( TileMatcher.new(tilemap,libraries[0]))
	stageMatchers.push_back( TileMatcher.new(tilemap,libraries[1]))
	stageMatchers.push_back( TileMatcher.new(tilemap,libraries[2]))
	print(TileMatcher.new(tilemap,libraries[0]))

func _process(delta):
	var matcher = stageMatchers[stage]
#	print(matcher)
	
#	clock += delta
#	if clock > spawnPerSecond and not done:
#
#		var i = 0
#		while i < loopsPerUpdate:
#			#gencheck stores array with data on generation
#			var genCheck = matcher.generate()
#
#			if not genCheck[2]:
#				stage += 1
#				if stage > 0: #end on specific stage
#					done = true
#					print("Done yeeting")
#
#			clock = 0
#			i += 1
	
	#enter to  reload scene and regenerate
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()

