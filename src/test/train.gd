extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	_make_layout()
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		_make_layout()
	
func _make_layout():
	var grid = _make_floor_layout()
	var defaults = grid.defaultTiles
	var cells = grid.get_used_cells()
	for pos in cells:
		grid.set_cellv(pos,_rand_tile(defaults))
	pass

func _make_floor_layout():
	return $floor
	pass

func _rand_tile(defaults):
	return defaults[randi() % defaults.size()]
#	var tom = Array().count(