extends Node2D

var loc
onready var train = preload("res://src/test/test_objects/map_train/map_train.tscn")
onready var conn = preload("res://src/test/test_objects/map_train/map_train_connector.tscn")

func _ready():
	set_process(true)
	randomize()
	seed(randi())
	loc = randi()
	
	draw_train(90, 350, ran_color(), "train1")
	draw_train(80, 300, ran_color(), "train2")
	draw_train(70, 250, ran_color(), "train3")
	draw_train(50, 200, ran_color(), "train4")
	draw_train(40, 150, ran_color(), "train5")
	draw_train(30, 100, ran_color(), "train6")
	pass 

func draw_train(count=90, radius=350, color=Color(1,0,0,1), prnt="train1"):
	var num = 0
	var angle = 0
	var step = 2.0*PI / count
	
	while num < count:
		var car = train.instance()
		var dir =  Vector2(cos(angle),sin(angle))
		car.position = dir * radius
		car.rotation = angle + 2.0*PI/4
		car.set_modulate( color )
		get_node(prnt).add_child(car)
		
		num  += 1
		angle += step
		
	pass

func ran_color():
	return Color( rand_range(0.0,1.0),rand_range(0.0,1.0),rand_range(0.0,1.0),1)
