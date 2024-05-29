extends HBoxContainer

const CARD = preload("res://tools/minigames/social_warfare/card.tscn")

var current_card : Card

signal selected_card

func initiate():
	Global.player_cards.shuffle()
	for i in 4:
		var j = Global.player_cards[i]
		var a = CARD.instantiate()
		add_child(a)
		a.card_data = j
		a.apply_assets()
		a.connect("chosen", card_chosen)
		
func card_chosen(card : Card):
	current_card = card
	emit_signal("selected_card")
