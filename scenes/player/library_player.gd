extends CharacterBody3D

class_name LibraryPlayer

const SPEED = 2.0
const JUMP_VELOCITY = 1.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var dir = Vector2.RIGHT
var turning = false
var can_move = true
var collision_box_increment = 0.4

signal book_collected
signal bomb_hit

func _physics_process(delta):
	if can_move:
		if not is_on_floor():
			velocity.y -= gravity * delta
		
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
		
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

func _on_hurtbox_body_entered(body):
	if body.get_parent() is Book:
		emit_signal("book_collected")
		body.get_parent().queue_free()
		#move_collision_box($Hurtbox/CollisionShape3D.position.y + collision_box_increment)

func _on_hurtbox_2_body_entered(body):
	if body.get_parent() is Bomb:
		emit_signal("bomb_hit")
		body.get_parent().queue_free()
		#move_collision_box(0.4)

func move_collision_box(new_pos):
	$Hurtbox/CollisionShape3D.position.y = new_pos
