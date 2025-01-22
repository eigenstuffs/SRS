extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = Vector2.ZERO
var speed: float = 300

func _physics_process(delta):
	if Global.can_move:
		if not is_on_floor():
			velocity.y += gravity * delta
		
		#move_and_slide()
	else:
		velocity = Vector2.ZERO
