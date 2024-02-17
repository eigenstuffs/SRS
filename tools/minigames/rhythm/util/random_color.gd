class_name RandomColorGenerator

static var RNG = RandomNumberGenerator.new()

static func generate(seed : int) -> Vector4:
	const MIX_COLOR = Vector3(1.0, 1.0, 1.0)
	const MIX_FACTOR = 0.9
	RNG.seed = seed
	
	var color = MIX_FACTOR*Vector3(RNG.randf_range(0, 0.6), RNG.randf_range(0, 0.6), RNG.randf_range(0, 0.6)) + (1 - MIX_FACTOR)*MIX_COLOR

	return Vector4(color.x, color.y, color.z, 1.0)
