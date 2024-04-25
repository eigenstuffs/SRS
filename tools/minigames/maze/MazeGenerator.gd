extends Node3D

#credit to: https://www.youtube.com/watch?v=_aeYq5BmDMg
class_name MazeGenerator

@onready var mazeCell = preload("res://tools/minigames/maze/maze_cell.tscn")
@onready var points = preload("res://tools/minigames/maze/points.tscn")

@export var mazeWidth : int
@export var mazeLength : int
var mazeGrid : Array
var pointGrid : Array

func _ready():
	for i in range(mazeWidth):
		mazeGrid.append([])
		pointGrid.append([])
		for j in range(mazeLength):
			var newCell : MazeCell = mazeCell.instantiate()
			newCell.position = Vector3(i, 0.5, j)
			add_child(newCell)
			mazeGrid[i].append(newCell)
			if (i == mazeWidth - 1 and j == mazeLength - 1) or (i == 0 && j == 0):
				#add a point if it's not starting and ending block
				pass
			else:
				var newPoint : Points = points.instantiate()
				newPoint.position = Vector3(i, 1, j)
				add_child(newPoint)
				pointGrid[i].append(newPoint)
	
	generateMaze(null, mazeGrid[0][0])

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
