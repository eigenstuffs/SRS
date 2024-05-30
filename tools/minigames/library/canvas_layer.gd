extends CanvasLayer

const FILLED_HEART = preload("res://assets/library/Heart_Filled.png")
const EMPTY_HEART = preload("res://assets/library/Heart_Empty.png")
var heart_array : Array

func _ready():
	for child in $HBoxContainer.get_children():
		heart_array.append(child)
		child.texture = FILLED_HEART

func remove_heart():
	if heart_array.size() > 0:
		heart_array[heart_array.size() - 1].texture = EMPTY_HEART
		heart_array.pop_back()
