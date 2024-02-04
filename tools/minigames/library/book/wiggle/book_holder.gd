extends Node3D

const BONE = preload('res://tools/minigames/library/book/wiggle/book_bone.tscn')

@onready var skeleton : Skeleton3D = $Skeleton3D

func _ready() -> void:
	skeleton.clear_bones()
	
func add_book_bone() -> void:
	var bone_idx = skeleton.get_bone_count()
	var bone : WiggleBone = BONE.instantiate()
	var angle : float = bone.properties.max_degrees
	bone.bone_name = 'bone%d' % bone_idx
	bone.bone_idx = bone_idx
	bone.properties.max_degrees = max(5, 15 - bone_idx*bone_idx/36)
	print(bone.properties.max_degrees)
	
	skeleton.add_bone(bone.bone_name)
	skeleton.set_bone_parent(bone_idx, bone_idx - 1)
	skeleton.add_child(bone)
	if bone_idx > 0: 
		skeleton.set_bone_pose_rotation(bone_idx, Quaternion.from_euler(Vector3(0.035, 30, -0.035) * randf_range(-1, 1)))
		skeleton.set_bone_pose_position(bone_idx, Vector3(0, 0.185, 0))

func get_num_books() -> int:
	return skeleton.get_bone_count()
