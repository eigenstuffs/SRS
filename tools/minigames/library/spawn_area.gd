class_name SpawnArea extends CSGPolygon3D

@onready var tris : PackedInt32Array = Geometry2D.triangulate_polygon(self.polygon)

var cumulated_areas : Array

func _ready() -> void:	
	var triangle_count: int = tris.size() / 3
	assert(triangle_count > 0)
	
	cumulated_areas.resize(triangle_count)
	cumulated_areas[-1] = 0
	for i in range(triangle_count):
		var a: Vector2 = self.polygon[tris[3 * i + 0]]
		var b: Vector2 = self.polygon[tris[3 * i + 1]]
		var c: Vector2 = self.polygon[tris[3 * i + 2]]
		cumulated_areas[i] = cumulated_areas[i - 1] + triangle_area(a, b, c)
		
func get_random_point() -> Vector3:
	var total_area : float = cumulated_areas[-1]
	var choosen_triangle_index : int = cumulated_areas.bsearch(randf() * total_area)
	var a : Vector2 = self.polygon[tris[3 * choosen_triangle_index + 0]]
	var b : Vector2 = self.polygon[tris[3 * choosen_triangle_index + 1]]
	var c : Vector2 = self.polygon[tris[3 * choosen_triangle_index + 2]]
	var rand_local_point : Vector2 = random_triangle_point(a, b, c)
	# Correct for rotation and scaling (assumes 90deg euler x)
	var global_offset = Vector3(rand_local_point.x, 0, rand_local_point.y) * Vector3(scale.x, scale.z, scale.y)
	
	return global_position + global_offset


static func triangle_area(a: Vector2, b: Vector2, c: Vector2) -> float:
	return 0.5 * abs((c.x - a.x) * (b.y - a.y) - (b.x - a.x) * (c.y - a.y))

static func random_triangle_point(a: Vector2, b: Vector2, c: Vector2) -> Vector2:
	return a + sqrt(randf()) * (-a + b + randf() * (c - b))
