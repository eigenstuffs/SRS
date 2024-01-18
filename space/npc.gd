extends Area3D

class_name NPC

@export var idle : Texture
@export var selected : Texture

@export_node_path("CharacterBody3D") var player_node
var player : Player = null

func _ready():
	player = get_node(player_node)
	
func _process(_delta):
	if player != null:
		if global_position.x - player.global_position.x >= 0:
			self.scale = Vector3(-1, 1, 1)
		else:
			self.scale = Vector3(1,1,1)

func in_range():
	$Sprite3D.texture = selected

func out_range():
	$Sprite3D.texture = idle
