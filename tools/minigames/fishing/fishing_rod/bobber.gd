extends RigidBody3D

signal water_entered

@onready var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

var is_in_water : bool = false
var original_position : Transform3D = transform

func _ready():
	visible = false
	
func launch(initial_v : Vector3):
	is_in_water = false
	transform = original_position
	visible = true
	linear_velocity = Vector3.ZERO
	apply_central_impulse(initial_v)

func _on_area_3d_area_entered(area):
	if area.get_parent() is Water:
		is_in_water = true
		emit_signal("water_entered")
		visible = false
		transform = original_position
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO

func disappear():
	visible = false
	transform = original_position
