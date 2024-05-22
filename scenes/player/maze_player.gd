extends Player

class_name MazePlayer

@onready var DASH_SFX = preload("res://tools/minigames/maze/sound/dash.wav")

var can_dash : bool = true
var is_dashing : bool = false
var DASH_SPEED : float = 10
var dashing_dir : Vector3
var last_input_dir : Vector3
var speed_modifier : float = 1

func _physics_process(delta):
	if Global.can_move:
		if not is_on_floor():
			velocity.y -= gravity * delta
		
		if is_dashing:
			velocity = dashing_dir * DASH_SPEED *speed_modifier
			velocity.y = 0
			move_and_slide()
			return

		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			last_input_dir = direction
		
		#BUG: space bar press not registered when two direction keys is held down at the same time
		if Input.is_action_just_pressed("ui_accept") and can_dash: 
			can_dash = false
			is_dashing = true
			$SfxPlayer.stream = DASH_SFX
			$SfxPlayer.play()
			if last_input_dir:
				dashing_dir = last_input_dir
			else:
				dashing_dir = Vector3.RIGHT
			collision_layer = 2
			collision_mask = 2
			dash_timer()
			return
				
		if direction:
			velocity.x = direction.x * SPEED *speed_modifier
			velocity.z = direction.z * SPEED *speed_modifier
			
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
			velocity.x = move_toward(velocity.x, 0, SPEED*speed_modifier)
			velocity.z = move_toward(velocity.z, 0, SPEED*speed_modifier)
			
		move_and_slide()
	else:
		velocity = Vector3.ZERO
	anim_handler()

func dash_timer():
	await get_tree().create_timer(0.25).timeout
	is_dashing = false
	can_dash = true
	print("dashing complete, giving immunity")
	await get_tree().create_timer(0.5).timeout
	collision_layer = 1
	collision_mask = 1
	
func set_speed_modifier(new : float):
	speed_modifier = new
