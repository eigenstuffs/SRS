class_name SocialWarfareFight extends Control

@onready var card_deck = $CardDeck
@onready var base_position := position

signal action

var current_action
var current_card : Card
var redraw_chance : int = 5

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

func _on_redraw_pressed():
	card_deck.discard_current_hand()
	reset()
	initiate()
	redraw_chance -= 1

func _process(delta):
	$Redraw/Label.text = "Redraw x " + str(redraw_chance)
	if redraw_chance < 1:
		$Redraw.disabled = true
	else: $Redraw.disabled = false
