extends Node3D

#credit to: https://www.youtube.com/watch?v=_aeYq5BmDMg
class_name MazeGenerator

signal key_collected
signal all_key_collected

@onready var mazeCell = preload("res://tools/minigames/maze/maze_cell.tscn")
@onready var keys = preload("res://tools/minigames/maze/keys.tscn")

@export var mazeWidth : int
@export var mazeLength : int
@export var keyN : int
var mazeGrid : Array
var keysCollected : int = 0

func _ready():
	for i in range(mazeWidth):
		mazeGrid.append([])
		for j in range(mazeLength):
			var newCell : MazeCell = mazeCell.instantiate()
			newCell.position = Vector3(i, 0.5, j)
			add_child(newCell)
			mazeGrid[i].append(newCell)
	
	generateMaze(null, mazeGrid[0][0])
	
	#place keys at random places
	var place_coords : Array = [[0, 0], [mazeWidth-1, mazeLength-1]]
	for i in range(keyN):
		var random_coords : Array = [randi_range(0, mazeWidth-1), randi_range(0, mazeLength-1)]
		while coords_too_close(place_coords, random_coords):
			#see if repeated location or too close to the starting point
			random_coords = [randi_range(0, mazeWidth-1), randi_range(0, mazeLength-1)]
		print(random_coords)
		place_coords.append(random_coords)
		var newKey : Keys = keys.instantiate()
		newKey.position = Vector3(random_coords[0], 0.8, random_coords[1])
		add_child(newKey)
		newKey.connect("collected", on_key_collected)
		

func coords_too_close(coords_array : Array, new_coords : Array) -> bool:
	var answer : bool = false
	for old_coords in coords_array:
		if abs(new_coords[0] - old_coords[0])^2 + abs(new_coords[1] - old_coords[1])^2 < 4:
			#radius of two
			answer = true
	
	return answer

func generateMaze(previousCell : MazeCell, currentCell : MazeCell):
	currentCell.visit()
	clearWalls(previousCell, currentCell)
	#await get_tree().create_timer(0.1).timeout
	
	var nextCell = getNextUnvisitedCell(currentCell)
	while nextCell != null:
		nextCell = getNextUnvisitedCell(currentCell)
		if nextCell != null:
			await generateMaze(currentCell, nextCell)
			#await for the recursive's complete signal, which won't be emitted until base case is reached

func getNextUnvisitedCell(currentCell : MazeCell) -> MazeCell:
	var unvisitedCells = getUnvisitedCells(currentCell)
	var nextCell = null
	if unvisitedCells.size() != 0:
		nextCell = unvisitedCells.pick_random()
	return nextCell
	
func getUnvisitedCells(currentCell : MazeCell) -> Array:
	var x : int = int(currentCell.position.x)
	var z : int = int(currentCell.position.z)
	
	var allUnvisited : Array = []
	if x + 1 < mazeWidth:
		var cellToRight = mazeGrid[x+1][z]
		if not cellToRight.isVisited:
			allUnvisited.append(cellToRight)
	if x - 1 >= 0:
		var cellToLeft = mazeGrid[x-1][z]
		if not cellToLeft.isVisited:
			allUnvisited.append(cellToLeft)
	if z + 1 < mazeLength:
		var cellToFront = mazeGrid[x][z + 1]
		if not cellToFront.isVisited:
			allUnvisited.append(cellToFront)
	if z - 1 >= 0:
		var cellToBack = mazeGrid[x][z-1]
		if not cellToBack.isVisited:
			allUnvisited.append(cellToBack)
	
	return allUnvisited
	

func clearWalls(previousCell, currentCell):
	if previousCell == null:
		return
	if previousCell.position.x < currentCell.position.x:
		previousCell.clearRight()
		currentCell.clearLeft()
		return
	if previousCell.position.x > currentCell.position.x:
		previousCell.clearLeft()
		currentCell.clearRight()
		return
	if previousCell.position.z < currentCell.position.z:
		previousCell.clearFront()
		currentCell.clearBack()
		return
	if previousCell.position.z > currentCell.position.z:
		previousCell.clearBack()
		currentCell.clearFront()
		return

func on_key_collected():
	keysCollected += 1
	emit_signal("key_collected")
	if keysCollected == keyN:
		emit_signal("all_key_collected")
