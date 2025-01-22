class_name SpawnArea extends CSGPolygon3D
## A editor-specific utility describing a 2D spawn area defined by a polygon.
## Source: https://www.reddit.com/r/godot/comments/mqp29g/comment/hddil1b/
##
## [b]Note:[/b] The transform rotation of the spawn area [b]must not be changed[/b]
##   as it is assumed that the spawn area is parallel to the x-z plane!

@onready var tris : PackedInt32Array = Geometry2D.triangulate_polygon(self.polygon)

var cumulated_areas : Array

func _ready() -> void:
	var triangle_count := int(tris.size() / 3.0)
	assert(triangle_count > 0)
	
	cumulated_areas.resize(triangle_count)
	cumulated_areas[-1] = 0
	for i in range(triangle_count):
		var tri : Array = _get_tri(i)
		cumulated_areas[i] = cumulated_areas[i - 1] + get_tri_area(tri[0], tri[1], tri[2])
		
func get_random_point() -> Vector3:
	# We choose a random triangle from our subdivided polygon, then choose a 
	# point within the chosen triangle
	var total_area : float = cumulated_areas[-1]
	var choosen_triangle_index : int = cumulated_areas.bsearch(randf() * total_area)
	var tri : Array = _get_tri(choosen_triangle_index)
	var rand_local_point : Vector2 = get_random_tri_point(tri[0], tri[1], tri[2])
	
	# Correct for rotation and scaling (assumes 90deg euler x)
	var global_offset = Vector3(rand_local_point.x, 0, rand_local_point.y) * Vector3(scale.x, scale.z, scale.y)
	
	return global_position + global_offset

## Get the triangle, based on its polygon index, as an array of three 2D points
func _get_tri(i : int) -> Array:
	return [self.polygon[tris[3 * i + 0]], self.polygon[tris[3 * i + 1]], self.polygon[tris[3 * i + 2]]]

func get_tri_area(a: Vector2, b: Vector2, c: Vector2) -> float:
	return 0.5 * abs((c.x - a.x) * (b.y - a.y) - (b.x - a.x) * (c.y - a.y))

func get_random_tri_point(a: Vector2, b: Vector2, c: Vector2) -> Vector2:
	return a + sqrt(randf()) * (-a + b + randf() * (c - b))
