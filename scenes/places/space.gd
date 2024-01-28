extends Node3D

var turns = 5

@export_node_path("Player") var player

func _ready():
	var p : Player = get_node(player)
	p.connect("interact", interacted)
	
func interacted():
	pass
