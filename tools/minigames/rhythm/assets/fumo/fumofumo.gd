extends Node3D

var pulse_time_start : float = -1
var time : float = 0
var scale_delta : float = 0.6

@onready var start_scale : float = scale.z

func _process(delta: float) -> void:
	time += delta
	
	rotation.z += deg_to_rad(180 * delta)
	if pulse_time_start != -1:
		var pulse_time_elapsed = time - pulse_time_start
		scale.z = start_scale * (1.0 - smoothstep(1, 0, abs(pulse_time_elapsed - 0.1))) * scale_delta + (1.0 - scale_delta)
		scale.z = min(scale.z, start_scale)

func _on_audio_synchronizer_on_beat() -> void:
	pulse_time_start = time
