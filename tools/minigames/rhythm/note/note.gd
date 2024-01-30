class_name Note extends Node3D

@export var duration_seconds : float = 1
@export var key_position : Vector3 = Vector3.ZERO

var mesh : MeshInstance3D :
	set(value):
		mesh = value
		if mesh: mesh.set_instance_shader_parameter('target_position', key_position)

var time : float = 0
var is_held : bool = false

func _ready() -> void:
	mesh = $Mesh

## Returns some scoring based on the provided hit position
func hit(z : float) -> float:
	queue_free()
	return z - global_position.z

func hold(z : float) -> void:
	if mesh and !is_held: mesh.set_instance_shader_parameter('should_hide_at_target_position', true)
	is_held = true

## Returns some scoring based on the provided release position
func release(z : float) -> float:
	if mesh and is_held: mesh.set_instance_shader_parameter('should_hide_at_target_position', false)
	is_held = false
	return 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
