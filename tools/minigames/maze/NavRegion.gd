extends NavigationRegion3D

@onready var mazeGenerator : MazeGenerator = $MazeGenerator

func _on_maze_generator_setup_complete():
	bake_navigation_mesh()
	await bake_finished
	print("baking complete!")
	mazeGenerator.enable_enemy_navigation()
	
