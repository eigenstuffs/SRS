class_name Book extends Node3D
## Webster dictionary
##
## [b]Note:[/b] While the cull mask for [member Book.RigidBody] is set to 1,
##   the layer mask is initially 0. When the book hits a physics body with layer
##   1, it will switch its layer mask to also be 1. This is so that falling books
##   can never interact with other falling books, while grounded books can.

const BOOK1 = preload("res://assets/library/book1-1.png")
const BOOK2 = preload("res://assets/library/book2-1.png")
const BOOK3 = preload("res://assets/library/book3-1.png")

@export var floor_position_y : float = 0.0
@export var fall_speed : float = 1.0

@onready var shadow : Shadow = $Shadow
@onready var rigid_body : RigidBody3D = $RigidBody
#@onready var mesh : MeshInstance3D = $RigidBody/BookMesh
@onready var origin_y : float = global_position.y

var has_collided : bool = false
var fade_time_seconds : float = 0.5
var fade_alpha_start : float

func _ready() -> void:
	var rand_int = randi_range(0, 3)
	match rand_int:
		0: $RigidBody/Sprite3D.texture = BOOK1
		1: $RigidBody/Sprite3D.texture = BOOK2
		2: $RigidBody/Sprite3D.texture = BOOK3
		_: $RigidBody/Sprite3D.texture = BOOK1
	$RigidBody/Sprite3D.rotation_degrees = Vector3(randf_range(0, 45), randf_range(0, 45), randf_range(0, 45))
	shadow.radius = 0
	shadow.alpha = 0

func _physics_process(delta: float) -> void:
	if not has_collided:
		# Fall at constant speed (no acceleration) until colliding
		rigid_body.translate(fall_speed * delta * Vector3.DOWN)
	
	if not is_instance_valid(shadow): return
	
	var physics_position = rigid_body.global_transform.origin
	var dist = physics_position.y - floor_position_y
	# Smoothie smoothie blah blah
	var t = 1 - dist / (origin_y - floor_position_y)
	t = clampf(1 - pow(2, -10*t), 0, 1)
	
	shadow.global_position = physics_position
	shadow.radius = t
	shadow.alpha = t

func _on_rigid_body_body_entered(_body: Node) -> void:
	rigid_body.call_deferred('set_contact_monitor', false)
	rigid_body.max_contacts_reported = 0
	rigid_body.freeze = false
	#rigid_body.collision_layer |= 0b01
	
	# To increase visual clarity, fade out shadow once book has hit the ground
	shadow.fade_out()
	has_collided = true
	await get_tree().create_timer(3).timeout
	queue_free()


func _on_shadow_on_fully_faded() -> void:
	# Allow shadows on book to increase visual clarity for other falling books.
	#mesh.layers |= 0b10
	pass
