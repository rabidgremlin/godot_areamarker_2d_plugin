extends Node2D

@onready var mouse_pos_label = $MousePosLabel

@onready var area_marker_2d_left = $AreaMarker2DLeft
@onready var area_marker_2d_right = $AreaMarker2DRight
@onready var area_marker_2d_top = $AreaMarker2DTop
@onready var area_marker_2d_bottom = $AreaMarker2DBottom


func _process(delta):
	# demo/test has_point logic by grabbing mouse location 
	# and seeing which side of the screen it is on by checking
	# if it is in area_marker_2d_left or area_marker_2d_right
	var global_mouse_position = get_global_mouse_position()
	mouse_pos_label.text = "MOUSE POS IS UNKNOWN"
	if area_marker_2d_left.has_point(global_mouse_position):
		mouse_pos_label.text = "YOUR MOUSE IS ON THE LEFT"
	if area_marker_2d_right.has_point(global_mouse_position):
		mouse_pos_label.text = "YOUR MOUSE IS ON THE RIGHT"	
	
