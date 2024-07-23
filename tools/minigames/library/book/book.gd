class_name Book extends Node3D
## Webster dictionary
##
## [b]Note:[/b] While the cull mask for [member Book.RigidBody] is set to 1,
##   the layer mask is initially 0. When the book hits a physics body with layer
##   1, it will switch its layer mask to also be 1. This is so that falling books
##   can never interact with other falling books, while grounded books can.

@export var floor_position_y : float = 0.0
@export var fall_speed : float = 1.0

@onready var shadow : Shadow = $Shadow
@onready var rigid_body : RigidBody3D = $RigidBody
#@onready var mesh : MeshInstance3D = $RigidBody/BookMesh
@onready var origin_y : float = global_position.y


@onready var cover := $RigidBody/bookwcel/Cover
var has_collided : bool = false
var fade_time_seconds : float = 0.5
var fade_alpha_start : float

func _ready() -> void:
	shadow.radius = 0
	shadow.alpha = 0

func _physics_process(delta: float) -> void:
	if not has_collided:
		# Fall at constant speed (no acceleration) until colliding
		rigid_body.translate(fall_speed * delta * Vector3.DOWN)
	
	if not is_instance_valid(shadow): return
	
	var physics_position = rigid_body.global_transform.origin
	#var dist = physics_position.y - floor_position_y
	## Smoothie smoothie blah blah
	#var t = 1 - dist / (origin_y - floor_position_y)
	#t = clampf(1 - pow(2, -10*t), 0, 1)
	#
	shadow.global_position = physics_position
	shadow.radius = 0.0
	shadow.alpha = 0.0
	shadow.fade_out()

func _on_rigid_body_body_entered(_body: Node) -> void:
	rigid_body.call_deferred('set_contact_monitor', false)
	rigid_body.max_contacts_reported = 0
	rigid_body.freeze = false
	rigid_body.collision_layer |= 0b01
	
	# To increase visual clarity, fade out shadow once book has hit the ground
	#shadow.fade_out()
	has_collided = true
	await get_tree().create_timer(6).timeout
	rigid_body.freeze = true


func _on_shadow_on_fully_faded() -> void:
	# Allow shadows on book to increase visual clarity for other falling books.
	#mesh.layers |= 0b10
	pass
