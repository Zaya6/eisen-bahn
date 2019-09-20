tool
extends TileMap

export(Color) var lineColor = Color(1,0,1,0.6)
export(int) var width = 5
export(int) var height = 5

func _draw():
	var cursor = 0
	while cursor < 64 * width:
		draw_line(Vector2(cursor, 0),Vector2(cursor,height*64),lineColor,1, true)
		cursor += 64
		
	cursor = 0
	while cursor < 64 * height:
		draw_line(Vector2(0,cursor),Vector2(width*64, cursor),lineColor,1, true)
		cursor += 64
	
	draw_rect(Rect2(0,0,width*64,height*64),lineColor, false)


func _process(delta):
	update()

