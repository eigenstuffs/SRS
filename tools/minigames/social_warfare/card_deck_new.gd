extends HBoxContainer

const CARD = preload("res://tools/minigames/social_warfare/card.tscn")

const CARD_LIST = preload("res://resources/cards/CardList.tres")

var current_card : Card
var current_hand = []
var load_saved_hand : bool = false

signal selected_card

func initiate():
	if load_saved_hand:
		for i in current_hand:
			var a = CARD.instantiate()
			add_child(a)
			a.card_data = i
			a.apply_assets()
			a.connect("chosen", card_chosen)
	else:
		CARD_LIST.card_list.shuffle()
		current_hand = []
		for i in 4:
			var j = CARD_LIST.card_list[i]
			var a = CARD.instantiate()
			add_child(a)
			a.card_data = j
			a.apply_assets()
			a.connect("chosen", card_chosen)
			current_hand.append(j)
		
func card_chosen(card : Card):
	current_card = card
	load_saved_hand = false
	emit_signal("selected_card")

func keep_current_hand():
	load_saved_hand = true
