extends Node2D

@onready var mouse_pos_label = $MousePosLabel

@onready var area_marker_2d_left = $AreaMarker2DLeft
@onready var area_marker_2d_right = $AreaMarker2DRight
@onready var area_marker_2d_top = $AreaMarker2DTop
@onready var area_marker_2d_bottom = $AreaMarker2DBottom
@onready var sprite = $Sprite
@onready var target = $Target

func _ready():
	randomize()
	_move_target()
	
func _move_target():
	# if target is in the top area then move it to random location in bottom area
	if area_marker_2d_top.has_point(target.position):				
		target.position = area_marker_2d_bottom.get_random_point() 			
	else:	
		target.position = area_marker_2d_top.get_random_point() 		

func _process(delta):
	# demo/test has_point() logic by grabbing mouse location 
	# and seeing which side of the screen it is on by checking
	# if it is in area_marker_2d_left or area_marker_2d_right
	var global_mouse_position = get_global_mouse_position()
	mouse_pos_label.text = "MOUSE POS IS UNKNOWN"
	if area_marker_2d_left.has_point(global_mouse_position):
		mouse_pos_label.text = "YOUR MOUSE IS ON THE LEFT"
	if area_marker_2d_right.has_point(global_mouse_position):
		mouse_pos_label.text = "YOUR MOUSE IS ON THE RIGHT"	
		
	# demo/test get_random_point() by miving random target around and
	# having sprite move to it	
	if sprite.position.distance_to(target.position) > 5: # Small threshold to prevent jitter
		var direction = (target.position - sprite.position).normalized()
		sprite.position += direction * 300 * delta
	else:
		# close enough to target, so move it 
		_move_target()
		
	
