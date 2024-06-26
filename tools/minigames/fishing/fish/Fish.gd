extends CharacterBody3D

class_name Fish

signal im_lured
signal im_hooked

var speed : float
var rarity : String
var bite_strength : float
var sell_price : int
@onready var skin : Sprite3D = $Sprite3D

#const JUMP_VELOCITY = 4.5
enum STATES { WANDER, WAIT, PURSUE, STOP}

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
#var direction = Vector3.ZERO
var state: STATES = STATES.WANDER
var bobber : FloatingBobber

func _ready():
	rotate_y(randf_range(-PI/2, PI/2)) #initialize so that they don't all swim forward together
	$Timer.start(randf_range(1.5, 3))
	
func _physics_process(delta):
	if state == STATES.WANDER:
		velocity = Vector3.FORWARD * speed
		velocity = velocity.rotated(Vector3.UP, rotation.y)
		$AnimationPlayer.play("wander")
	elif state == STATES.WAIT:
		velocity.x = 0
		velocity.z = 0
		$AnimationPlayer.play("stop")
	elif state == STATES.PURSUE:
		#look_at(bobber.global_position)
		var dir : Vector3 = bobber.global_position - self.global_position
		if(dir.length() <= 0.25):
			state = STATES.STOP
		else:
			dir.normalized()
			velocity.x = dir.x * speed
			velocity.z = dir.z * speed
			$AnimationPlayer.play("pursue")
	elif state == STATES.STOP:
		velocity = Vector3.ZERO
		$AnimationPlayer.play("stop")
	move_and_slide()


#makes the fish switch states every 2-3 seconds i think
func _on_timer_timeout():
	if state == STATES.WANDER:
		state = STATES.WAIT
	elif state == STATES.WAIT:
		state = STATES.WANDER
		#is this line needed??
		rotation = rotation.normalized()
		rotate_y(randf_range(0, 2*PI))
	$Timer.start(randf_range(2, 3))

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()

func _on_hurtbox_area_entered(area):
	if area.get_name() == "CatchField":
		emit_signal("im_hooked")
	if area.get_parent() is FloatingBobber and state != STATES.PURSUE:
		state = STATES.PURSUE
		bobber = area.get_parent()
		emit_signal("im_lured")

func _on_hurtbox_area_exited(area):
	if area.get_parent() is FloatingBobber and state == STATES.PURSUE:
		state = STATES.WANDER
