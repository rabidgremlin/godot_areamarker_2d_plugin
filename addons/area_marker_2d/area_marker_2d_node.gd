@tool
class_name AreaMarker2D
extends Node2D

@export var size:Vector2 = Vector2(50,50):
	set(new_size):
		size=new_size
		_reclaculate_rect()
		queue_redraw()
		
@export var offset:Vector2:
	set(new_offset):
		offset=new_offset
		_reclaculate_rect()
		queue_redraw()	
		
@export var color:Color = Color.DARK_ORCHID:
	set(new_color):
		color=new_color		
		queue_redraw()		
		
@export var filled:bool = false:
	set(new_filled):
		filled=new_filled		
		queue_redraw()			
		
var _rect: Rect2			

func _reclaculate_rect():
	_rect = Rect2(-1.0*size/2+offset,size)	
		
func _draw():
	if Engine.is_editor_hint():
		draw_rect(_rect,color,filled)
		
		
func has_point(point:Vector2) -> bool:
	var rect_global = Rect2(global_position + _rect.position, _rect.size)
	return rect_global.has_point(point)
	
func get_random_point() -> Vector2:
	var rect_global = Rect2(global_position + _rect.position, _rect.size)
	var random_x = randf_range(rect_global.position.x, rect_global.position.x + rect_global.size.x)
	var random_y = randf_range(rect_global.position.y, rect_global.position.y + rect_global.size.y)
	return Vector2(random_x,random_y)
		
		
		
			
