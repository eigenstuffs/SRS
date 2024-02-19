extends Control

#@onready var text = $TextEdit
@onready var minigame_list : ItemList = $ItemList

func _ready() -> void:
	for name in MinigameRegistry.minigames:
		minigame_list.add_item('  %s' % name)

#func _on_skip_pressed():
	#Util.create_minigame($CanvasLayer, $TextEdit.text)
 
func _on_item_list_item_activated(index: int) -> void:
	var name : String = minigame_list.get_item_text(index).strip_edges()
	Util.create_minigame($CanvasLayer, name)
	minigame_list.focus_mode = Control.FOCUS_NONE
