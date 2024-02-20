extends CharacterBody3D

class_name FishingPlayer

signal casting_time
signal fishing_time
signal walking_time
signal fish_hooked

@onready var rod = $FishingRod

const SPEED = 2.0
const JUMP_VELOCITY = 1.5

enum FishingState {
	WALKING, CASTING, FISHING, REELING
}

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var dir = Vector2.RIGHT
var turning = false
var currentState = FishingState.WALKING

func _ready():
	currentState = FishingState.WALKING
	
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if currentState == FishingState.WALKING:
			currentState = FishingState.CASTING
			emit_signal("casting_time")
	if Input.is_action_just_released("ui_accept"):
		if currentState == FishingState.CASTING:
			currentState = FishingState.FISHING
			emit_signal("fishing_time") #the third state depends on the fishing rod
	if Global.can_move and currentState == FishingState.WALKING:
		if not is_on_floor():
			velocity.y -= gravity * delta
		
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
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


func _on_fishing_rod_fishing_ends():
	currentState = FishingState.WALKING
	

func _on_fishing_rod_fish_hooked():
	emit_signal("fish_hooked")


func _on_fishing_reeling_minigame():
	rod.retractable = false

func _on_fishing_reeling_minigame_end(is_successful):
	rod.retractable = true
	rod.retract_bobber()
