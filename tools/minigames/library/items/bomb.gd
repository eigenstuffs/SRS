extends RigidBody2D

class_name Bomb

@onready var destruct_timer = $DestructTimer

func _ready():
	contact_monitor = true
	max_contacts_reported = 2

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Ground"):
		destruct_timer.start()
	elif body.is_in_group("Player"):
		queue_free()

func _on_destruct_timer_timeout() -> void:
	queue_free()
