extends Node3D

const BONE = preload('res://tools/minigames/library/book/wiggle/book_bone.tscn')

@onready var skeleton : Skeleton3D = $Skeleton3D

func _ready() -> void:
	skeleton.clear_bones()
	
func add_book_bone(book : Book) -> void:
	var bone_idx = skeleton.get_bone_count()
	var bone : WiggleBone = BONE.instantiate()
	bone.bone_name = 'bone%d' % bone_idx
	bone.bone_idx = bone_idx
	bone.properties.max_degrees = max(5.0, 15.0 - bone_idx*bone_idx/36.0)
	
	skeleton.add_bone(bone.bone_name)
	skeleton.set_bone_parent(bone_idx, bone_idx - 1)
	skeleton.add_child(bone)
	if bone_idx > 0: 
		skeleton.set_bone_pose_rotation(bone_idx, book.quaternion)
		skeleton.set_bone_pose_position(bone_idx, Vector3(0, 0.185, 0))

func get_num_books() -> int:
	return skeleton.get_bone_count()

func clear_all_books() -> void:
	if get_num_books() > 10:
		EffectRegistry.stop_effect("Vignette")
	skeleton.clear_bones()
	for child in skeleton.get_children():
		child.queue_free()
