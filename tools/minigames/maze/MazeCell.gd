extends Node3D

class_name MazeCell

@onready var leftWall : StaticBody3D = $LeftWall
@onready var rightWall : StaticBody3D = $RightWall
@onready var frontWall : StaticBody3D = $FrontWall
@onready var backWall : StaticBody3D = $BackWall
@onready var unvisitedBlock : StaticBody3D = $UnvisitedBlock

var isVisited : bool = false

func visit():
	isVisited = true
	remove_child(unvisitedBlock)

func clearLeft():
	remove_child(leftWall)
	
func clearRight():
	remove_child(rightWall)
	
func clearFront():
	remove_child(frontWall)

func clearBack():
	remove_child(backWall)
