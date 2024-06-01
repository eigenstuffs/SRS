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
	
	$CanvasLayer/Opponent/BarHP.max_value = enemy_data.enemy_hp
	$CanvasLayer/Opponent/BarMP.max_value = enemy_data.enemy_mp
	$CanvasLayer/Player/BarHP.max_value = Global.data_dict["player_max_hp"]
	$CanvasLayer/Player/BarMP.max_value = Global.data_dict["player_max_mp"]
	
func turn_loop():
	refresh_stats()
	fight.reset()
	choose.hide()
	fight.hide()
	match STATE:
		STATES.PLAYER:
			choose.show()
			await choose.chosen
			choose.hide()
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
							STATE = STATES.OPPONENT

				"flee":
					pass
			
			turn_loop()
		STATES.OPPONENT:
			card_action(
				enemy_move(), "Player"
			)
			await card_action_finished
			
			STATE = STATES.PLAYER
			turn_loop()
	
func card_action(card : Card, target : String):
	print(card.title)
	battle_intensity += card.intensity_mod
	Global.data_dict["player_mp"] -= card.points_req
	
	## put dialogue somewhere in here
	
	match target:
		"Player":
			match card.effect:
				0:
					Global.data_dict["player_hp"] -= (card.effect_num *
						enemy_data.enemy_offense_ratio)
				1:
					enemy_data.enemy_hp += card.effect_num
				2:
					match card.target_stat:
						0:
							enemy_data.enemy_offense_ratio *= card.effect_num
						1:
							enemy_data.enemy_defense_ratio *= card.effect_num
					buff_applied = true
				3:
					match card.target_stat:
						0:
							Global.data_dict["player_offense_ratio"] *= card.effect_num
						1:
							Global.data_dict["player_defense_ratio"] *= card.effect_num
					buff_applied = true
		"Opponent":
			match card.effect:
				0: #attack
					enemy_data.enemy_hp -= (card.effect_num *
						Global.data_dict["player_offense_ratio"])
				1: #restore
					Global.data_dict["player_hp"] += card.effect_num
				2: #buff
					print("buff")
					match card.target_stat:
						0: # attack
							Global.data_dict["player_offense_ratio"]*= card.effect_num
						1: # defense
							Global.data_dict["player_defense_ratio"] *= card.effect_num
					buff_applied = true
				3: #debuff
					print("debuff")
					match card.target_stat:
						0: # attack
							enemy_data.enemy_offense_ratio *= card.effect_num
						1: # defense
							enemy_data.enemy_defense_ratio *= card.effect_num
					buff_applied = true
	if buff_applied:
		buff_applied = false
	else:
		print("Wiped buffs")
		Global.data_dict["player_offense_ratio"] = 1
		Global.data_dict["player_defense_ratio"] = 1
		enemy_data.enemy_offense_ratio = 1
		enemy_data.enemy_defense_ratio = 1
	refresh_stats()
	await get_tree().create_timer(0.5).timeout
	emit_signal("card_action_finished")

func enemy_move():
	enemy_data.enemy_cards.shuffle()
	return enemy_data.enemy_cards[0]

func refresh_stats():
	var a = create_tween()
	a.tween_property(
		$CanvasLayer/Player/BarHP, "value",
		Global.data_dict["player_hp"], 0.5).set_trans(Tween.TRANS_EXPO)
	a = create_tween()
	a.tween_property(
		$CanvasLayer/Player/BarMP, "value",
		Global.data_dict["player_mp"], 0.5).set_trans(Tween.TRANS_EXPO)
	a = create_tween()
	a.tween_property(
		$CanvasLayer/Opponent/BarHP, "value",
		enemy_data.enemy_hp, 0.5).set_trans(Tween.TRANS_EXPO)
	a = create_tween()
	a.tween_property(
		$CanvasLayer/Opponent/BarMP, "value",
		enemy_data.enemy_mp, 0.5).set_trans(Tween.TRANS_EXPO)
