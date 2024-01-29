class_name Note extends Node3D

@export var duration_seconds : float = 1
@export var key_position : Vector3 = Vector3.ZERO :
	set(value):
		key_position = value
		_on_set_key_position(value)

var time : float = 0

## Returns some scoring based on the provided hit position
func hit(z : float) -> float:
	queue_free()
	return z - global_position.z

func hold(z : float) -> void: pass

## Returns some scoring based on the provided release position
func release(z : float) -> float: return 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta

func _on_set_key_position(value : Vector3) -> void:
	$Mesh.set_instance_shader_parameter('target_position', value)
