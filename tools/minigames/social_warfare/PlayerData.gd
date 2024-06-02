class_name EnemyData extends Node

const CARD_LIST = preload("res://resources/cards/CardList.tres")

@export var enemy_name : String
@export var enemy_hp : int = 10
@export var enemy_mp : int = 5  
@export var enemy_defense_ratio : float = 1
@export var enemy_offense_ratio : float = 1

@onready var enemy_cards : Array = CARD_LIST.card_list
