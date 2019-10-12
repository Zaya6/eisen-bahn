extends Node2D

export(float) var spawnPerSecond = 0
export(int) var loopsPerUpdate = 1
export(int) var spawnSeed = 11111
export(bool) var randomSeed = false
export(NodePath) var seedLabel

# stamp libraries and matchers
var libraryNames = ["train_test","train_test_2","train_test_3"]
var library1 : Array
var library2 : Array
var library3 : Array
var stageMatcher1:TileMatcher
var stageMatcher2:TileMatcher
var stageMatcher3:TileMatcher


#internal variables
var tilemap:TileMap
var stage : int = 1
var clock:float = 0
var done: bool = false
var sizeCheck = 10
var lastSize = 0
var finalTrainSize = 0
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
	
	sizeCheck = int(rand_range(15, 20))
	finalTrainSize = int(rand_range(50, 100))

func _process(delta):
	clock += delta
	if clock > spawnPerSecond and not done:
		clock = 0
		var matcher
		match stage:
			1:
				matcher = stageMatcher1
			2:
				matcher = stageMatcher2
			3: 
				matcher = stageMatcher3
			
		#gencheck stores array with data on generation
		var genCheck = matcher.generate()
		lastSize = genCheck[0].size.y
		
		#check each stage
		match stage:
			1: # check if car is big enough, if it is start another
				if lastSize > sizeCheck:
					print(str(lastSize) + ":" + str(stage))
					stage = 2
			2: # Restart another traincar if generation hasn't reached finalTrainSize
				if not genCheck[2]: 
					print(str(lastSize) + ":" + str(stage))
					if lastSize > finalTrainSize:
						stage = 3
					else:
						stage = 1
						sizeCheck = lastSize + int(rand_range(15,20))
			3: # if finalTrainSize has been passed, put top on last car
				if not genCheck[2]:
					print(str(lastSize) + ":" + str(stage))
					done = true
					
			
	#enter to  reload scene and regenerate
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()

