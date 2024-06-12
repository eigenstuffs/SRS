class_name SocialWarfareFight extends Control

@onready var card_deck = $CardDeck
@onready var base_position := position

signal action

var current_action
var current_card : Card

func _on_back_pressed():
	current_action = "back"
	emit_signal("action")

func initiate():
	card_deck.initiate()

func _on_card_deck_selected_card():
	current_card = card_deck.current_card
	current_action = "card"
	emit_signal("action")

func reset():
	for i in $Cards.get_children():
		$Cards.remove_child(i)
		i.queue_free()
	for i in $CardDeck.get_children():
		$CardDeck.remove_child(i)
		i.queue_free()

func keep_current_hand():
	card_deck.keep_current_hand()
