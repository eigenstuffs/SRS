extends CharacterBody3D

class_name Fish

@export var speed = 0.6
@export var rarity = 1
@export var bite_time = 2
@export var sell_price = 5

#const JUMP_VELOCITY = 4.5
enum STATES { WANDER, WAIT }

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
#var direction = Vector3.ZERO
var state: STATES = STATES.WANDER


func _physics_process(delta):
	if state == STATES.WANDER:
		velocity = Vector3.FORWARD * speed
		velocity = velocity.rotated(Vector3.UP, rotation.y)
	elif state == STATES.WAIT:
		velocity.x = 0
		velocity.z = 0
		
	move_and_slide()


#makes the fish switch states every 3 seconds i think
func _on_timer_timeout():
	if state == STATES.WANDER:
		state = STATES.WAIT
	else:
		state = STATES.WANDER
		#is this line needed??
		rotation = rotation.normalized()
		rotate_y(randf_range(0, 2*PI))
	$Timer.start(3)

func _on_visible_on_screen_notifier_3d_screen_exited():
	pass
	#queue_free()
