extends Node



class Stamp:
	var width = 0
	var height = 0
	var name = ""
	var location = ""
	
	func _init(nw,nh,nn,nl):
		width = nw
		height = nh
		name = nn
		location =nl

var train_basic = [
	Stamp.new(18, 3, "train_walls", "res://src/stamps/train_base/walls_stamp.png")
	]
	