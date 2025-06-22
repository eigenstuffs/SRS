extends RigidBody2D

class_name Book

const TEXTURE_DICT: Dictionary = {
	0: "res://assets/library/book1-1.png",
	1: "res://assets/library/book2-1.png",
	2: "res://assets/library/book3-1.png"
}

@onready var destruct_timer: Timer = $DestructTimer

func apply_random_texture():
	var random_num := randi_range(0, TEXTURE_DICT.keys().size())
	$Sprite2D.texture = load(TEXTURE_DICT.get(random_num, "res://assets/library/book1-1.png"))

func _ready():
	apply_random_texture()
	#contact_monitor = true
	#max_contacts_reported = 1

#func _on_body_entered(body: Node) -> void:
	#if body.is_in_group("Ground"):
		#destruct_timer.start()
#
#func _on_destruct_timer_timeout() -> void:
	#queue_free()
