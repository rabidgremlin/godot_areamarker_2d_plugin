# Godot AreaMarker2D plugin
Godot 4.4+ plugin to add an AreaMarker2D node and editor tools to make visual positioning and sizing of the area easy.

The AreaMarker2D functions like the Marker2D node but encapsulates a 2D area.

It exposes the following functions:

| Function | Description |
|----------|-------------|  
|has_point(point:Vector2) -> bool |Returns true if the point is inside the area.|
|get_random_point() -> Vector2 | Returns a random point inside the area.|

## Installation
1. Download this code repo as a .zip file.
2. Extract the contents of `addons` into your Godot project's `addons` folder.

## Notes
This code is based on:

* How to Create a 2d Manipulator in Godot 3.1: Editor Plugin Overview: https://www.youtube.com/watch?v=H6TfKYtuM9U
* RectExtents Gizmo from the Godot OpenRPG project: https://github.com/gdquest-demos/godot-open-rpg/blob/f2326e28ac0ec85a5ec9469838e9f89992f951f8/godot/addons/rect_extents_gizmo/plugin.gd
