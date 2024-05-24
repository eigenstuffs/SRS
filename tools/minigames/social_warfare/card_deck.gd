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
		get_child(i).position = Vector2(i*323, 0)
		self.position = self.position - Vector2(323*0.5, 0)
		get_child(i).original_pos = get_child(i).global_position
