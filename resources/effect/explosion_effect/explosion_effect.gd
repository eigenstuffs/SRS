class_name ExplosionEffect extends Node3D

func start_anticiation() -> void:
	$Flash.emitting = true
	$ClinkSound.playing = true
	
func start_explosion() -> void:
	$Sparks.emitting = true
	$Fire.emitting = true
	$Smoke.emitting = true
	$ExplosionSound.pitch_scale = randf_range(1.2, 1.6)
	$ExplosionSound.playing = true
