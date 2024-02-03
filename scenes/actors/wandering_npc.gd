extends CharacterBody3D

class_name WanderingNPC

const SPEED = 1.5
const JUMP_VELOCITY = 1.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var dir = Vector2.RIGHT
var orientation : Vector3 = Vector3(1, 0, 0)
var turning = false

func _physics_process(delta):
	if Global.can_move:
		if not is_on_floor():
			velocity.y -= gravity * delta
		
		var direction = orientation.normalized()
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			
			var last_dir = dir
			
			if velocity.x > 0:
				dir = Vector2.RIGHT
			else:
				dir = Vector2.LEFT
				
			if dir != last_dir:
				if dir == Vector2.RIGHT:
					$Sprite3D.scale = Vector3(0.5,0.5,0.5)
				else:
					$Sprite3D.scale = Vector3(-0.5,0.5,0.5)
				if not turning:
					var a = create_tween()
					turning = true
					a.tween_property($Sprite3D, "position", $Sprite3D.position + Vector3(0,.1,0), 0.1)
					await a.finished
					a = create_tween()
					a.tween_property($Sprite3D, "position", $Sprite3D.position - Vector3(0,.1,0), 0.1)
					await a.finished
					turning = false
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			
		move_and_slide()
	else:
		velocity = Vector3.ZERO
	anim_handler()

func anim_handler():
	if velocity != Vector3.ZERO:
		$AnimationPlayer.play("Walk")
	else:
		$AnimationPlayer.play("Idle")

func _on_visible_on_screen_enabler_3d_screen_exited():
	queue_free()
