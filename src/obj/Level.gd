extends Node2D

export(String) var libraryName = ""
export(float) var spawnPerSecond = 0
export(int) var loopsPerUpdate = 1
export(int) var spawnSeed = 11111
export(bool) var randomSeed = false
export(NodePath) var seedLabel

#internal variables
var library:Array
var tilemap:TileMap
var tileMatcher
var clock:float = 0
var done: bool = false

func _ready():
	if randomSeed: 
		randomize();
		spawnSeed = randi() % 9999999
	
	get_node(seedLabel).text = str(spawnSeed)
	
	seed(spawnSeed)
	
	library = EB.stampLibraries[libraryName]
	tilemap = $TileMap
	tileMatcher = TileMatcher.new(tilemap,library)

func _process(delta):
	clock += delta
	if clock > spawnPerSecond and not done:
		
		var i = 0
		while i < loopsPerUpdate:
			var genCheck = tileMatcher.generate()
			var genArea = genCheck[0].size.x * genCheck[0].size.y
			if genArea > 500:#not genCheck[2]:
				if tilemap.get_used_cells_by_id(27).size() > 0: #stops when it hits end of hall
					done = true
					print("Done yeeting")
			clock = 0
			i += 1
	
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()
	
