@tool
extends EditorPlugin

var selected_area_marker: AreaMarker2D

enum Anchors {
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT
}

var anchors : Array
var dragged_anchor : Dictionary = {}

const CIRCLE_RADIUS : float = 3.0
const STROKE_RADIUS : float = 1.0
const FILL_COLOR = Color("#FF5F5F")
const STROKE_COLOR = Color("#ffffff")
const OUTER_STROKE_COLOR = Color("#000000")
const SELECT_COLOR = Color("#C9825E")

func _enter_tree():
	# Initialization of the plugin goes here.
	# Add the new type with a name, a parent type, a script and an icon.
	add_custom_type("AreaMarker2D", "Node2D", preload("area_marker_2d_node.gd"), preload("area_marker_2d_node.svg"))

func _exit_tree():
	# Clean-up of the plugin goes here.
	# Always remember to remove it from the engine when deactivated.
	remove_custom_type("AreaMarker2D")
	
	
func _edit(object):
	print("Selected AreaMarker2D is:", object)
	selected_area_marker = object
	update_overlays()
	
func _make_visible(visible):	
	if not selected_area_marker:
		return
	if not visible:
		selected_area_marker = null
	update_overlays()
	
func _handles(object) -> bool:
	print("Checking if can handle:",object)
	return object is AreaMarker2D
	
func _forward_canvas_draw_over_viewport(viewport_control):
	if not selected_area_marker or not selected_area_marker.is_inside_tree():
		return
	
	var pos = selected_area_marker.position
	var offset = selected_area_marker.offset
	var half_size : Vector2 = selected_area_marker.size / 2.0
	var edit_anchors : = {
		Anchors.TOP_LEFT: pos - half_size + offset,
		Anchors.TOP_RIGHT: pos + Vector2(half_size.x, -1.0 * half_size.y) + offset,
		Anchors.BOTTOM_LEFT: pos + Vector2(-1.0 * half_size.x, half_size.y) + offset,
		Anchors.BOTTOM_RIGHT: pos + half_size + offset,
	}
	
	var transform_viewport : = selected_area_marker.get_viewport_transform()
	var transform_global : = selected_area_marker.get_canvas_transform()
	anchors = []
	var anchor_size : Vector2 = Vector2(CIRCLE_RADIUS * 2.0, CIRCLE_RADIUS * 2.0)
	for coord in edit_anchors.values():
		var anchor_center : Vector2 = transform_viewport * (transform_global * coord)
		var new_anchor = {
			'position': anchor_center,
			'rect': Rect2(anchor_center - anchor_size / 2.0, anchor_size),
		}		
		anchors.append(new_anchor)	
		
	# draw selection rect	
	var top_left_anchor_pos = anchors[Anchors.TOP_LEFT]["position"]
	var bottom_right_anchor_pos = anchors[Anchors.BOTTOM_RIGHT]["position"]
	var selection_rect = Rect2(top_left_anchor_pos.x,top_left_anchor_pos.y,bottom_right_anchor_pos.x-top_left_anchor_pos.x,bottom_right_anchor_pos.y-top_left_anchor_pos.y)
	viewport_control.draw_rect(selection_rect,SELECT_COLOR,false)
	
	# draw anchors
	for anchor in anchors:
		_draw_anchor(anchor, viewport_control)	

func _draw_anchor(anchor : Dictionary, overlay : Control) -> void:
	var pos = anchor['position']
	overlay.draw_circle(pos, CIRCLE_RADIUS + STROKE_RADIUS*2, OUTER_STROKE_COLOR,true,-1,true)
	overlay.draw_circle(pos, CIRCLE_RADIUS + STROKE_RADIUS, STROKE_COLOR,true,-1,true)
	overlay.draw_circle(pos, CIRCLE_RADIUS, FILL_COLOR,true,-1,true)	
	
func drag_to(event_position: Vector2) -> void:
	if not dragged_anchor:
		return
	# Calculate the position of the mouse cursor relative to the RectExtents' center
	var viewport_transform_inv := selected_area_marker.get_viewport().get_global_canvas_transform().affine_inverse()
	var viewport_position: Vector2 = viewport_transform_inv * event_position
	var transform_inv := selected_area_marker.get_global_transform().affine_inverse()
	var target_position : Vector2 = transform_inv * viewport_position.round()
	# Update the rectangle's size. Only resizes uniformly around the center for now
	var target_size = (target_position - selected_area_marker.offset).abs() * 2.0
	selected_area_marker.size = target_size		
	
func _forward_canvas_gui_input(event):		
	if not selected_area_marker or not selected_area_marker.visible:
		return false

	# Clicking and releasing the click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not dragged_anchor and event.is_pressed():
			for anchor in anchors:
				if not anchor['rect'].has_point(event.position):
					continue
				var undo := get_undo_redo()
				undo.create_action("Move anchor")
				undo.add_undo_property(selected_area_marker, "size", selected_area_marker.size)
				undo.add_undo_property(selected_area_marker, "offset", selected_area_marker.offset)
				dragged_anchor = anchor
				print("Drag start: %s" % dragged_anchor)
				return true
		elif dragged_anchor and not event.is_pressed():
			print("Lifting the cursor: %s" % event.position)
			drag_to(event.position)
			dragged_anchor = {}
			var undo := get_undo_redo()
			undo.add_do_property(selected_area_marker, "size", selected_area_marker.size)
			undo.add_do_property(selected_area_marker, "offset", selected_area_marker.offset)
			undo.commit_action()
			return true
	if not dragged_anchor:
		return false
	# Dragging
	if event is InputEventMouseMotion:
		drag_to(event.position)
		update_overlays()
		return true
	# Cancelling with ui_cancel
	if event.is_action_pressed("ui_cancel"):
		dragged_anchor = {}
		var undo := get_undo_redo()
		undo.commit_action()
		undo.undo()
		return true
	return false
