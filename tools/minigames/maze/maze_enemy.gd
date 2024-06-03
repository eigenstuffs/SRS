extends CharacterBody3D

class_name MazeEnemy

signal met_player
signal direction_cooldown

@onready var player : Player = get_tree().get_first_node_in_group("Player")
const SPEED = 1.0
const ACCEL = 10
const JUMP_VELOCITY = 1.5

enum STATES {WALK, WAIT}
var currState : STATES

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var dir = Vector3.RIGHT
var spawn_point : Vector3 = Vector3()
var possible_dirs : Array[Vector3] = [Vector3.RIGHT, Vector3.LEFT, Vector3.FORWARD, Vector3.BACK]
var can_change : bool = true
@export var dir_cooldown : float = 0.5
var speed_modifier : float = 1
var can_move = false

func _ready():
	spawn_point = global_position
	currState = STATES.WAIT
	#player = get_node(player_node)

func _physics_process(delta):
	$Hurtbox/Indicator.set_rotation_degrees($Hurtbox/Indicator.rotation_degrees + Vector3(0, 25 * delta, 0))
	if can_move:
		if not is_on_floor():
			velocity.y -= gravity * delta
		
		if is_on_wall() and can_change:
			dir = possible_dirs.pick_random()
			can_change = false
			emit_signal("direction_cooldown")
			
		
		velocity.x = dir.x * SPEED * speed_modifier
		velocity.z = dir.z * SPEED * speed_modifier
		move_and_slide()

func _on_hurtbox_body_entered(body):
	if body is Player:
		emit_signal("met_player")

func _on_direction_cooldown():
	await get_tree().create_timer(dir_cooldown).timeout
	can_change = true

func set_speed_modifier(new: float):
	speed_modifier = new
