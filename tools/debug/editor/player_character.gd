extends CharacterBody3D

@export var max_speed = 5
@export var acceleration = 600
@export var jump_velocity = 4.5

@export var look_sensitivity = 0.0017 #ProjectSettings.get_setting('player/look_sensitivity')
@export var gravity = 9.8 #ProjectSettings.get_setting('physics/3d/default_gravity')
var velocity_y = 0

@export var camera : Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	var horizontal_velocity = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down').normalized()
	horizontal_velocity = horizontal_velocity.x * global_transform.basis.x + horizontal_velocity.y * global_transform.basis.z
	#velocity = horizontal_velocity.x * global_transform.basis.x + horizontal_velocity.y * global_transform.basis.z
	velocity = velocity.move_toward(horizontal_velocity * max_speed, delta * acceleration)
	
	if is_on_floor():
		velocity_y = jump_velocity if Input.is_action_just_pressed('ui_accept') else 0
	else:
		velocity_y -= gravity * delta
	velocity.y = velocity_y
	move_and_slide()
	
	if Input.is_action_just_pressed('ui_cancel'):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
		
func _input(event):
	if (Input.mouse_mode == Input.MOUSE_MODE_VISIBLE):
		return
	
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * look_sensitivity)
		camera.rotate_x(-event.relative.y * look_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI / 2, PI / 2)
	
