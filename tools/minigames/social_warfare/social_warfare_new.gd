class_name SocialWarfare extends Control

enum STATES {
	PLAYER,
	OPPONENT
}

var STATE : STATES = STATES.PLAYER

var battle_intensity : int = 0

var buff_applied : bool = false

@onready var choose = $CanvasLayer/Choice
@onready var fight = $CanvasLayer/Fight
@onready var enemy_data : EnemyData = $EnemyData

signal card_action_finished
signal enemy_move_finished

func _ready():
	turn_loop()
	
func turn_loop():
	fight.reset()
	choose.hide()
	fight.hide()
	match STATE:
		STATES.PLAYER:
			choose.show()
			await choose.chosen
			match choose.current_choice:
				"fight":
					fight.show()
					fight.initiate()
					await fight.action
					match fight.current_action:
						"back":
							pass
						"card":
							card_action(fight.current_card, "Opponent")
							await card_action_finished
							print("action done")

				"flee":
					pass
			
			STATE = STATES.OPPONENT
			turn_loop()
		STATES.OPPONENT:
			STATE = STATES.PLAYER
			turn_loop()

func card_action(card : Card, target : String):
	battle_intensity += card.intensity_mod
	Global.player_mp -= card.points_req
	
	## put dialogue somewhere in here
	
	match target:
		"Player":
			match card.effect:
				"Attack":
					Global.player_hp -= (card.effect_num *
						enemy_data.enemy_offense_ratio)
				"Restore":
					enemy_data.enemy_hp += card.effect_num
				"Buff":
					match card.target_stat:
						"Attack":
							enemy_data.enemy_offense_ratio *= card.effect_num
						"Defense":
							enemy_data.enemy_defense_ratio *= card.effect_num
					buff_applied = true
				"Debuff":
					match card.target_stat:
						"Attack":
							Global.player_offense_ratio *= card.effect_num
						"Defense":
							Global.player_defense_ratio *= card.effect_num
					buff_applied = true
		"Opponent":
			match card.effect:
				"Attack":
					enemy_data.enemy_hp -= (card.effect_num *
						Global.player_offense_ratio)
				"Restore":
					Global.player_hp += card.effect_num
				"Buff":
					match card.target_stat:
						"Attack":
							Global.player_offense_ratio *= card.effect_num
						"Defense":
							Global.player_defense_ratio *= card.effect_num
					buff_applied = true
				"Debuff":
					match card.target_stat:
						"Attack":
							enemy_data.enemy_offense_ratio *= card.effect_num
						"Defense":
							enemy_data.enemy_defense_ratio *= card.effect_num
					buff_applied = true
	if buff_applied:
		buff_applied = false
	else:
		Global.player_offense_ratio = 1
		Global.player_defense_ratio = 1
		enemy_data.enemy_offense_ratio = 1
		enemy_data.enemy_defense_ratio = 1
	emit_signal("card_action_finished")

func enemy_move():
	enemy_data.enemy_cards.shuffle()
	return enemy_data.enemy_cards[0]
