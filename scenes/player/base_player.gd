extends CharacterBody2D

class_name BasePlayer

#@onready var timer : Timer = $Timer
const SPEED = 350
const JUMP_VELOCITY = 1.5

var default_scale: Vector2
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dir = Vector2.RIGHT
var turning = false
var can_move = true
var speed_multiplier : float = 1
var hurt : bool = false
var fail : bool = false

func _ready():
	default_scale = $AnimatedSprite2D.scale
	pass

func _physics_process(delta):
	if can_move:
		if not is_on_floor():
			velocity.y += gravity * delta
		
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = input_dir.normalized()
		
		if direction:
			velocity.x = direction.x * SPEED * speed_multiplier
			
			var last_dir = dir
			
			if velocity.x > 0:
				dir = Vector2.RIGHT
			else:
				dir = Vector2.LEFT
				
			if dir != last_dir:
				if dir == Vector2.RIGHT:
					$AnimatedSprite2D.scale = default_scale #adujsted because of sprite sheet size
				else:
					$AnimatedSprite2D.scale = Vector2(-default_scale.x, default_scale.y)
				if not turning:
					var a = create_tween()
					turning = true
					a.tween_property($AnimatedSprite2D, "position", $AnimatedSprite2D.position + Vector2(0,.1), 0.1)
					await a.finished
					a = create_tween()
					a.tween_property($AnimatedSprite2D, "position", $AnimatedSprite2D.position - Vector2(0,.1), 0.1)
					await a.finished
					turning = false
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED*speed_multiplier)
			
		move_and_slide()
	else:
		velocity = Vector2.ZERO
	anim_handler()

func anim_handler():
	if hurt:
		$AnimatedSprite2D.play("Hurt")
	elif velocity != Vector2.ZERO:
		$AnimatedSprite2D.play("Walk")
	elif hurt:
		$AnimatedSprite2D.play("Hurt")
	elif fail:
		$AnimatedSprite2D.play("Fail")
	else:
		$AnimatedSprite2D.play("Idle")

func set_hurt(duration: int):
	hurt = true
	can_move = false
	await get_tree().create_timer(duration).timeout
	hurt = false
	can_move = true
