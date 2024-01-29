class_name HitSliderTick extends Node3D

@onready var mesh : MeshInstance3D = $Mesh;

var time : float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mesh.set_instance_shader_parameter('alpha', min(1.0, time * 1.5))
	time += delta

func _on_visibility_notifier_screen_exited() -> void:
	queue_free()
