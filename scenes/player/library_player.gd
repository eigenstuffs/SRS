extends CharacterBody3D

class_name LibraryPlayer

@onready var timer : Timer = $Timer
const SPEED = 2.0
const JUMP_VELOCITY = 1.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var dir = Vector2.RIGHT
var turning = false
var can_move = true
var collision_box_increment = 0.15
var original_hurtbox_y : float
var speed_multiplier : float = 1
var hurt : bool = false
var fail : bool = false

signal book_collected(book : Book)
signal bomb_hit(bomb : Bomb)

func _ready():
	original_hurtbox_y = $Hurtbox.position.y
	timer.start(3) #unused timer

func _physics_process(delta):
	if can_move:
		if not is_on_floor():
			velocity.y -= gravity * delta
		
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
		
		if direction:
			velocity.x = direction.x * SPEED *speed_multiplier
			velocity.z = direction.z * SPEED *speed_multiplier
			
			var last_dir = dir
			
			if velocity.x > 0:
				dir = Vector2.RIGHT
			else:
				dir = Vector2.LEFT
				
			if dir != last_dir:
				if dir == Vector2.RIGHT:
					$AnimatedSprite3D.scale = Vector3(0.1,0.1,0.1) #adujsted because of sprite sheet size
				else:
					$AnimatedSprite3D.scale = Vector3(-0.1,0.1,0.1)
				if not turning:
					var a = create_tween()
					turning = true
					a.tween_property($AnimatedSprite3D, "position", $AnimatedSprite3D.position + Vector3(0,.1,0), 0.1)
					await a.finished
					a = create_tween()
					a.tween_property($AnimatedSprite3D, "position", $AnimatedSprite3D.position - Vector3(0,.1,0), 0.1)
					await a.finished
					turning = false
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED*speed_multiplier)
			velocity.z = move_toward(velocity.z, 0, SPEED*speed_multiplier)
			
		move_and_slide()
	else:
		velocity = Vector3.ZERO
	anim_handler()

func anim_handler():
	if velocity != Vector3.ZERO:
		$AnimatedSprite3D.play("Walk")
	elif hurt:
		$AnimatedSprite3D.play("Hurt")
	elif fail:
		$AnimatedSprite3D.play("Fail")
	else:
		$AnimatedSprite3D.play("Idle")

func _on_hurtbox_body_entered(body):
	var parent = body.get_parent()
	#if parent is Book:
		#emit_signal("book_collected", parent)
		#parent.queue_free()
		#move_hurtbox($Hurtbox.position.y + collision_box_increment)
		#print([$Hurtbox.position.y, $Hurtbox/CollisionShape3D.position.y])

func _on_hurtbox_2_body_entered(body):
	var parent = body.get_parent()
	if parent is Bomb:
		emit_signal("bomb_hit", parent)
		#move_collision_box(0.4)

func move_hurtbox(new_pos = original_hurtbox_y):
	$Hurtbox.position.y = new_pos
