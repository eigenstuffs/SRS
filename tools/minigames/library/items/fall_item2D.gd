extends RigidBody2D

class_name FallItem2D

@export var floor_position_y : float = 0.0
@export var fall_speed : float = 1.0

@onready var origin_y : float = global_position.y

var has_collided : bool = false

func _physics_process(delta: float) -> void:
	if not has_collided:
		# Fall at constant speed (no acceleration) until colliding
		translate(fall_speed * delta * Vector2.DOWN)
		
	#if not is_instance_valid(shadow): return
	
	#For calculating shadow
	var physics_position = global_transform.origin
	var dist = physics_position.y - floor_position_y
	var t = 1 - dist / (origin_y - floor_position_y)
	t = clampf(1 - pow(2, -10*t), 0, 1)


func _on_body_entered(body):
	has_collided = true
	await get_tree().create_timer(3).timeout
	call_deferred("queue_free")
