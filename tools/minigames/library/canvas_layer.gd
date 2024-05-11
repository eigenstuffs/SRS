extends CanvasLayer

var heart_array : Array

func _ready():
	for child in $HBoxContainer.get_children():
		heart_array.append(child)

func remove_heart():
	if heart_array.size() > 0:
		heart_array[heart_array.size() - 1].queue_free()
		heart_array.pop_back()
