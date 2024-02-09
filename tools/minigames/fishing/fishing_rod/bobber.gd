extends RigidBody3D

@export var float_force : float = 8
@export var water_drag : float = 0.05
@export var water_angular_drag : float = 0.05

@onready var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

const water_height : float = 0.0

var submerged : bool = false
var in_water : bool = false

func _physics_process(delta):
	if in_water:
		submerged = false
		var depth = water_height - global_position.y
		if depth > 0:
			submerged = true
			apply_central_force(Vector3.UP * float_force * gravity * depth)
		
func _integrate_forces(state: PhysicsDirectBodyState3D):
	if submerged:
		state.linear_velocity *= 1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag

func launch(initial_v : Vector3):
	in_water = false
	apply_central_impulse(initial_v)
	print(linear_velocity)

func _on_area_3d_area_entered(area):
	if area.get_parent() is Water:
		in_water = true
		linear_velocity = Vector3.ZERO
		print("water entered")

func _on_area_3d_area_exited(area):
	if area.get_parent() is Water:
		in_water = false
