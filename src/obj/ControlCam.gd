extends Camera2D

export(float) var setZoom = 1

var nzoom = setZoom
var zoomTarget = setZoom
var move = Vector2(0.0, 0.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	zoomTarget = zoom.x
	nzoom = zoom.x
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("ui_page_up"):
		zoomTarget -= 0.05
	if Input.is_action_pressed("ui_page_down"):
		zoomTarget += 0.05
	
	if Input.is_action_pressed("ui_up"):
		move.y -= (50 + move.y * 0.1) * delta
	if Input.is_action_pressed("ui_down"):
		move.y += (50 + move.y * 0.1) * delta
	if Input.is_action_pressed("ui_right"):
		move.x += (50 + move.y * 0.1) * delta
	if Input.is_action_pressed("ui_left"):
		move.x -= 50 * delta
	
	offset += move
	move *= 0.9
	
	nzoom = lerp(nzoom, zoomTarget, 0.1)
	zoom = Vector2(nzoom, nzoom)
	
