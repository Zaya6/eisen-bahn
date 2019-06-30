extends Camera2D

var nzoom = 1
var zoomTarget = 1
var move = Vector2(0.0, 0.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	seed(555555)
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("ui_page_up"):
		zoomTarget +=0.05
	if Input.is_action_pressed("ui_page_down"):
		zoomTarget -=0.05
	
	if Input.is_action_pressed("ui_up"):
		move.y -= 50 * delta
	if Input.is_action_pressed("ui_down"):
		move.y += 50 * delta
	if Input.is_action_pressed("ui_right"):
		move.x += 50 * delta
	if Input.is_action_pressed("ui_left"):
		move.x -= 50 * delta
	
	offset += move
	move *= 0.9
	
	nzoom = lerp(nzoom, zoomTarget, 0.05)
	zoom = Vector2(nzoom, nzoom)
	
