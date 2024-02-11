extends RigidBody3D

@export var float_force : float = 8
@export var water_drag : float = 0.05
@export var water_angular_drag : float = 0.05

@onready var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

const water_height : float = 0.0

var submerged : bool = false

func _ready():
	visible = false

func _physics_process(delta):
	submerged = false
	var depth = water_height - global_position.y
	if depth > 0:
		submerged = true
		apply_central_force(Vector3.UP * float_force * gravity * depth)

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if submerged:
		state.linear_velocity *= 1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag
