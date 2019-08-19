extends Sprite
var target = Vector2(0,0)
var isMoving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	target = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if not isMoving:
		if Input.is_action_pressed("ui_left"):
			target.x -= 32
			isMoving = true
		if Input.is_action_pressed("ui_right"):
			target.x += 32
			isMoving = true
		if Input.is_action_pressed("ui_up"):
			target.y -= 32
			isMoving = true
		if Input.is_action_pressed("ui_down"):
			target.y += 32
			isMoving = true
	
	if isMoving:
		position += (target - position).normalized()*120*delta
		if (target - position).length() < 1:
			position = target
			isMoving = false
