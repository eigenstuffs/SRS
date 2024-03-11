extends RigidBody3D

class_name FloatingBobber

signal fish_hooked

@export var float_force : float = 8
@export var water_drag : float = 0.05
@export var water_angular_drag : float = 0.05

@onready var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var CatchField : Area3D = $CatchField
@onready var AttractionField: Area3D = $AttractionField

const water_height : float = 0.0

var submerged : bool = false

func _ready():
	visible = false
	CatchField.monitoring = false

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

func activate():
	visible = true
	CatchField.monitoring = true
	AttractionField.monitoring = true
	$Sprite3D.global_rotation = Vector3(0, 0, 0)
	$Sprite3D.scale = Vector3(0.1, 0.1, 0.1)

	
func deactivate():
	visible = false
	CatchField.monitoring = false
	AttractionField.monitoring = false
	
func disable_being_monitored():
	CatchField.monitorable = false
	AttractionField.monitorable = false

func enable_being_monitored():
	CatchField.monitorable = true
	AttractionField.monitorable = true
