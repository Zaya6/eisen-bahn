extends KinematicBody2D

export(int) var step = 64

var target = Vector2(0,0)
var oldTarget = Vector2(0,0)
var isMoving = false


# Called when the node enters the scene tree for the first time.
func _ready():
	target = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if not isMoving:
		oldTarget = target
		if Input.is_action_pressed("ui_left"):
			target.x -= step
			isMoving = true
		if Input.is_action_pressed("ui_right"):
			target.x += step
			isMoving = true
		if Input.is_action_pressed("ui_up"):
			target.y -= step
			isMoving = true
		if Input.is_action_pressed("ui_down"):
			target.y += step
			isMoving = true
	
	if isMoving:
		if move_and_collide((target - position).normalized()*120*delta):
			target = oldTarget
		if (target - position).length() < 1:
			position = target
			isMoving = false
