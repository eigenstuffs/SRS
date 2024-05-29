class_name CardDeck extends Control

const CARD = preload("res://tools/minigames/social_warfare/card.tscn")
const PLAYER_DATA = preload("res://resources/stats/player_stats.tres")

func _ready():
	for i : Card in PLAYER_DATA.cards:
		var a = CARD.instantiate()
		add_child(a)
		a.texture_normal = i.image
		a.card_data = i
	for i in get_child_count():
		get_child(i-1).global_position = Vector2((i-1)*(323), 0)
		get_child(i-1).original_pos = get_child(i-1).global_position
		get_child(i-1).global_position = get_child(i-1).original_pos
	global_position.x = global_position.x - (323 * 0.5 * get_child_count())
