extends CharacterBody3D

class_name Fish

#const JUMP_VELOCITY = 4.5
const SPEED = 0.6
enum STATES { WANDER, WAIT }

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
#var direction = Vector3.ZERO
var state: STATES = STATES.WANDER
var turning = false


func _physics_process(delta):
	#if not is_on_floor():
		#velocity.y -= gravity * delta
	
	if state == STATES.WANDER:
		velocity = Vector3.FORWARD * SPEED
		velocity = velocity.rotated(Vector3.UP, rotation.y)
	elif state == STATES.WAIT:
		velocity.x = 0
		velocity.z = 0
	
	if not turning:
		var a = create_tween()
		turning = true
		a.tween_property($Sprite3D, "position", position + Vector3(0,.1,0), 0.1)
		await a.finished
		a = create_tween()
		a.tween_property($Sprite3D, "position", position - Vector3(0,.1,0), 0.1)
		await a.finished
		turning = false
		
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

func _on_visible_on_screen_notifier_3d_screen_exited():
	pass
	#queue_free()
