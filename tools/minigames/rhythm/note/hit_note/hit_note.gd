class_name HitNote extends Note

@export var speed : float = 0 :
	set(value): 
		speed = value
		_on_set_speed()

func _on_set_speed() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	global_position.z += speed * delta

func _on_visibility_notifier_screen_exited():
	queue_free()
