class_name MinigameRegistry extends Node
## Static [class_name MinigameList] wrapper for easier global lookup. Depends on a
## predefined minigame list resource!

const MINIGAME_LIST_RESOURCE_DIR : String = 'res://tools/minigames/default_minigames.tres'

static var minigames : Dictionary = {}

static func _static_init() -> void:
	var minigame_list = load(MINIGAME_LIST_RESOURCE_DIR)
	for minigame in minigame_list.minigame_list:
		register(minigame)
	#minigames.make_read_only()
	
static func register(minigame : MinigameInfo) -> void:
	assert(minigame.name && minigame.scene && minigame.time != null)
	minigames[minigame.name] = minigame
	print('Registered minigame: %s' % minigame.name)
	
static func get_metadata(m_name : String) -> MinigameInfo:
	return minigames[m_name]

static func has_key(m_name : String) -> bool:
	return minigames.has(m_name)
