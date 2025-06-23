extends Node2D

@onready var particles = $GPUParticles2D

func _ready():
	particles.emitting = true
	await get_tree().create_timer(particles.lifetime).timeout
	queue_free()
