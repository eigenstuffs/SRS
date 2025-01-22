#Base class for the 2D Player
extends CharacterBody2D

class_name Player2D

const SPEED: float = 500

@onready var sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_move: bool = true
var dir = Vector2.RIGHT
var turning = false

func _ready():
	custom_ready()
	
func _physics_process(delta):
	if Global.can_move and can_move:
		if not is_on_floor():
			velocity.y += gravity * delta
		
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = Vector2(input_dir.x, input_dir.y).normalized()
		
		if direction:
			velocity.x = direction.x * SPEED
			
			var last_dir = dir
			
			if velocity.x > 0:
				dir = Vector2.RIGHT
			elif velocity.x < 0:
				dir = Vector2.LEFT
				
			if dir != last_dir:
				if dir == Vector2.RIGHT:
					sprite.scale = Vector2(0.25,0.25)
				else:
					sprite.scale = Vector2(-0.25,0.25)
				if not turning:
					var a = create_tween()
					turning = true
					a.tween_property(sprite, "position", sprite.position + Vector2(0,.1), 0.1)
					await a.finished
					a = create_tween()
					a.tween_property(sprite, "position", sprite.position - Vector2(0,.1), 0.1)
					await a.finished
					turning = false
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		custom_movement()
		move_and_slide()
	else:
		velocity = Vector2.ZERO
	anim_handler()

func anim_handler(): #can be overwritten based on the need of different player type
	if velocity != Vector2.ZERO:
		sprite.play("Walk")
	else:
		sprite.play("Idle")

func custom_movement(): #virtual function
	pass

func custom_ready(): #virtual function
	pass
