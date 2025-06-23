extends RigidBody2D

class_name Bomb

const EXPLOSION_EFFECT = preload("res://tools/minigames/library/items/explosion_effect.tscn")

@onready var destruct_timer = $DestructTimer

func _ready():
	contact_monitor = true
	max_contacts_reported = 2

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Ground") or body.is_in_group("FallingItems"):
		destruct_timer.start()
	elif body.is_in_group("Player"):
		queue_free()

func _on_destruct_timer_timeout() -> void:
	var a = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	a.tween_property(self, "modulate:a", 0, 0.5)
	await a.finished
	queue_free()

func trigger_explosion():
	var a = EXPLOSION_EFFECT.instantiate()
	get_parent().get_parent().add_child(a) #add to GameManager
	a.global_position = global_position
