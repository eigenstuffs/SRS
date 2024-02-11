@tool
class_name ScreenSpaceMesh extends MeshInstance3D
## A mesh that runs a screen-space shader... in screen-space.
##
## Instantiating as a child of a [code]Camera3D[/code] is not required. The node
## just needs to be placed within the scene tree.
##
## [b]Note:[/b] Make sure your fragment shader sets [code]ALPHA[/code] to 0 wherever
##   shading doesn't occur! This is the easiest way to permit multiple passes!

@export var screen_space_shader : ShaderMaterial : 
	set(value):
		screen_space_shader = value
		set_surface_override_material(0, screen_space_shader)
