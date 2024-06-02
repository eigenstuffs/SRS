extends Resource

class_name TutorialList

@export var tutorial_scene_list : Array[TutorialInfo]

func find_scene(minigame : String):
	var returned_scene
	for element in tutorial_scene_list:
		if element.name == minigame:
			returned_scene = element.scene
	return load(returned_scene)
