extends VBoxContainer

var health = 0
var money = 10
var intelligence = 20
var charisma = 10
var reputation = 5

@onready var stats = [health, money, intelligence, charisma, reputation]

func _process(delta):
	for i : int in self.get_child_count():
		get_child(i).min_value = 0
		get_child(i).max_value = 30
		get_child(i).value = stats[i]
