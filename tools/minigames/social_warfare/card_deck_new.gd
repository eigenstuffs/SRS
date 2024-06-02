extends HBoxContainer

const CARD = preload("res://tools/minigames/social_warfare/card.tscn")

const CARD_LIST = preload("res://resources/cards/CardList.tres")

var current_card : Card

signal selected_card

func initiate():
	CARD_LIST.card_list.shuffle()
	for i in 4:
		var j = CARD_LIST.card_list[i]
		var a = CARD.instantiate()
		add_child(a)
		a.card_data = j
		a.apply_assets()
		a.connect("chosen", card_chosen)
		
func card_chosen(card : Card):
	current_card = card
	emit_signal("selected_card")
