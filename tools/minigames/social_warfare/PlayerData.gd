class_name EnemyData extends Node

const CARD_LIST = preload("res://resources/cards/CardList.tres")

@export var enemy_name : String
@export var enemy_hp : int = 20
@export var enemy_mp : int = 10 
@export var enemy_max_hp : int = 20
@export var enemy_max_mp : int = 10
@export var enemy_defense_ratio : float = 1
@export var enemy_offense_ratio : float = 1
@export_enum("Backhanded", "Blunt", "Emotional") var enemy_type

@onready var enemy_cards : Array = CARD_LIST.card_list

func _ready():
	match enemy_name:
		"Esra":
			enemy_cards = CARD_LIST.esra_list
			
func get_best_card():
	var heal = []
	var other = []
	for i in enemy_cards:
		if i.points_req <= enemy_mp:
			if i.effect == 1:
				heal.append(i)
			else:
				other.append(i)
	if enemy_hp <= (enemy_max_hp * .2):
		var num = randi_range(0, 10)
		if num >= 1 and !heal.is_empty():
			heal.shuffle()
			return heal[0]
		else:
			other.shuffle()
			return other[0]
	elif enemy_hp <= (enemy_max_hp * .5):
		var num = randi_range(0, 10)
		if num >= 3 and !heal.is_empty():
			heal.shuffle()
			return heal[0] 
		else:
			other.shuffle()
			return other[0]
	elif enemy_hp == (enemy_max_hp):
		other.shuffle()
		return other[0]
	else:
		enemy_cards.shuffle()
		return enemy_cards[0]
