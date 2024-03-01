extends Resource

class_name RewardList

@export var reward_scene_list : Array[RewardInfo]

func find_scene(minigame : String):
	var returned_scene
	for element in reward_scene_list:
		if element.name == minigame:
			returned_scene = element.scene
	return load(returned_scene)
