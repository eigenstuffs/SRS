extends CharacterBody3D

class_name MazeEnemy

signal met_player

@export_node_path("CharacterBody3D") var player_node
@onready var player : Player = get_tree().get_first_node_in_group("Player")
const SPEED = 1.0
const JUMP_VELOCITY = 1.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var dir = Vector3.RIGHT

func _ready():
	pass
	#player = get_node(player_node)

func _physics_process(delta):
	if not is_on_floor():
			velocity.y -= gravity * delta
			
	if is_on_wall():
		dir = -dir
	
	velocity.x = dir.x * SPEED
	velocity.z = dir.z * SPEED
	
	move_and_slide()


func _on_hurtbox_body_entered(body):
	if body is Player:
		emit_signal("met_player")
