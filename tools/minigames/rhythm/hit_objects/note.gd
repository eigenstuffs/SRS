class_name Note extends Node3D

enum HitType {HIT, RELEASE, MISS}

@export var fade_in_distance : float = 1.5
@export var spawn_point : Node3D
@export var hit_point : Node3D

var timings_supplier : Callable ## Shape: () -> [time, scroll_time]
var hit_time : float = -1
var duration : float = -1
var is_held : bool = false
var is_missed : bool = false
		
func _ready() -> void:
	assert(timings_supplier, 'A timings supplier `Callable` must be assigned before _ready()!')
	assert(spawn_point and hit_point, 'Note endpoints must be assigned before _ready()!')

func hit() -> void: is_held = true

func release() -> void: is_held = false
	
func miss() -> void: is_missed = true
