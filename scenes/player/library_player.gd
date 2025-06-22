extends BasePlayer

class_name LibraryPlayer

@onready var push_area: Area2D = $PushArea

signal book_caught(amount: int)
signal bomb_caught()

func _on_catch_box_body_entered(body: Node2D) -> void:
	if body is Book:
		emit_signal("book_caught", 1)
		print("book caught!")
	elif body is Bomb:
		emit_signal("bomb_caught")
		set_hurt(1)

func _physics_process(delta: float) -> void:
	super(delta)
	_apply_push_to_books(dir)
	
func _apply_push_to_books(direction: Vector2):
	if direction == Vector2.ZERO:
		return

	for body in push_area.get_overlapping_bodies():
		if body is RigidBody2D:
			body.apply_central_impulse(direction.normalized() * 50)
