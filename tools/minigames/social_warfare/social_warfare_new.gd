class_name SocialWarfare extends Control

const MUSIC_SOCIAL_WARFARE = preload("res://assets/music/Villianess Reborn Battle Social Warfare Music 1.mp3")
const SFX_IMPACT_1 = preload("res://assets/sfx/impact_!.ogg")
const SFX_IMPACT_2 = preload("res://assets/sfx/impact_2.ogg")
const SFX_IMPACT_3 = preload("res://assets/sfx/impact_3.mp3")

enum STATES {
	PLAYER,
	OPPONENT
}

var STATE : STATES = STATES.PLAYER

var battle_intensity : int = 0

var buff_applied : bool = false

var shake_strength = 0
var shake_decay = 0

var battle_result : String #for calculating stats

@onready var choose = $Holder/Choice
@onready var fight = $Holder/Fight
@onready var flee = $Holder/Flee
@onready var enemy_data : EnemyData = $EnemyData
@onready var cam : Camera2D = $Camera2D

signal card_action_finished
signal enemy_move_finished

func _ready():
	EffectAnim.SfxPlayer.volume_db = -10
	if Global.data_dict["remembered"].has("SocialWarfare"):
		turn_loop()
	else:
		Util.show_tutorial("SocialWarfare", $RewardHolder)
		await Util.tutorial_finished
		turn_loop()
	$Holder/Opponent/BarHP.max_value = enemy_data.enemy_max_hp
	$Holder/Opponent/BarMP.max_value = enemy_data.enemy_max_mp
	$Holder/Player/BarHP.max_value = Global.data_dict["player_max_hp"]
	$Holder/Player/BarMP.max_value = Global.data_dict["player_max_mp"]

func game_start():
	turn_loop()

func turn_loop():
	refresh_stats()
	fight.reset()
	choose.hide()
	fight.hide()
	flee.hide()
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
							fight.keep_current_hand()
						"card":
							card_action(fight.current_card, "Opponent")
							await card_action_finished
							print("action done")
							STATE = STATES.OPPONENT
				"flee":
					flee.show()
					flee.initiate()
					await flee.finished
					match flee.escaped:
						true:
							flee_battle()
						false:
							print("failed flee")
							STATE = STATES.OPPONENT
							flee.hide()
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
	
	## anim handler
	
	match target:
		"Player":
			match card.effect:
				0:
					$EnemyData/Player.play("Damage")
				3:
					$EnemyData/Player.play("Damage")
				_:
					pass
		"Opponent":
			match card.effect:
				0:
					$EnemyData/Enemy.play("Damage")
				3:
					$EnemyData/Enemy.play("Damage")
				_:
					pass
	
	## print card title
	
	#$Background/Box.hide()
	$Holder/Fight.hide()
	
	match target:
		"Player":
			Util.popup_dialogue(
				$Holder/DialogueHolder,
				[enemy_data.enemy_name + " used " + card.title + "!"],
				["null"]
			)
			
			await Util.util_finished
		"Opponent":
			Util.popup_dialogue(
				$Holder/DialogueHolder,
				["You used " + card.title + "!"],
				["null"]
			)
			
			await Util.util_finished
	
	## put dialogue somewhere in here
	
	if card.move_dialogue:
		var index = randi_range(0, card.move_dialogue.size()-1)
		Util.popup_dialogue(
			$Holder/DialogueHolder,
			[card.move_dialogue[index]],
			[card.name_dialogue[index]]
		)
		
		await Util.util_finished
		
	#$Background/Box.show()
	
	## type advantage multiplier
	
	var enemy_type = enemy_data.enemy_type
	var card_type = card.type
	
	var multiple = 1.0
	match target:
		"Player":
			match card_type:
				"Backhanded":
					match enemy_type:
						"Blunt":
							multiple = 1.2
						"Emotional":
							multiple = 0.8
				"Blunt":
					match card_type:
						"Backhanded":
							multiple = 0.8
						"Emotional":
							multiple = 1.2
				"Emotional":
					match card_type:
						"Blunt":
							multiple = 0.8
						"Backhanded":
							multiple = 1.2
		"Opponent":
			match enemy_type:
				"Backhanded":
					match card_type:
						"Blunt":
							multiple = 1.2
						"Emotional":
							multiple = 0.8
				"Blunt":
					match card_type:
						"Backhanded":
							multiple = 0.8
						"Emotional":
							multiple = 1.2
				"Emotional":
					match card_type:
						"Blunt":
							multiple = 0.8
						"Backhanded":
							multiple = 1.2
	
	## apply effect
	
	match randi_range(0,2):
		0:
			EffectAnim.SfxPlayer.stream = SFX_IMPACT_1
			EffectAnim.SfxPlayer.play()
		1:
			EffectAnim.SfxPlayer.stream = SFX_IMPACT_2
			EffectAnim.SfxPlayer.play()
		_:
			EffectAnim.SfxPlayer.stream = SFX_IMPACT_3
			EffectAnim.SfxPlayer.play()
	
	match target:
		"Player":
			match card.effect:
				0:
					Global.data_dict["player_hp"] -= (card.effect_num *
						enemy_data.enemy_offense_ratio) * multiple
					start_shake(card.effect_num, card.effect_num * 2)
				1:
					enemy_data.enemy_hp += card.effect_num * multiple
				2:
					match card.target_stat:
						0:
							enemy_data.enemy_offense_ratio *= (card.effect_num)
							Util.popup_dialogue(
								$CanvasLayer,
								[enemy_data.enemy_name + "'s offense rose!"],
								["null"]
							)
							await Util.util_finished
						1:
							enemy_data.enemy_defense_ratio *= (card.effect_num)
							Util.popup_dialogue(
								$Holder/DialogueHolder,
								[enemy_data.enemy_name + "'s defense rose!"],
								["null"]
							)
							await Util.util_finished
					buff_applied = true
				3:
					match card.target_stat:
						0:
							multiple = 1 + (1 - multiple)
							Global.data_dict["player_offense_ratio"] *= (card.effect_num * multiple)
							Util.popup_dialogue(
								$Holder/DialogueHolder,
								["Your offense fell!"],
								["null"]
							)
							await Util.util_finished
						1:
							multiple = 1 + (1 - multiple)
							Global.data_dict["player_defense_ratio"] *= (card.effect_num * multiple)
							Util.popup_dialogue(
								$Holder/DialogueHolder,
								["Your defense fell!"],
								["null"]
							)
							await Util.util_finished
					buff_applied = true
			Global.data_dict["player_mp"] += 3
		"Opponent":
			match card.effect:
				0: #attack
					enemy_data.enemy_hp -= (card.effect_num *
						Global.data_dict["player_offense_ratio"] * multiple)
					start_shake(card.effect_num, card.effect_num * 2)
				1: #restore
					match card.target_stat:
						2: # health
							Global.data_dict["player_hp"] += (card.effect_num * multiple)
						3: # mp
							Global.data_dict["player_mp"] += (card.effect_num * multiple)
				2: #buff
					print("buff")
					match card.target_stat:
						0: # attack
							Global.data_dict["player_offense_ratio"]*= (card.effect_num*multiple)
							Util.popup_dialogue(
								$Holder/DialogueHolder,
								["Your offense rose!"],
								["null"]
							)
							await Util.util_finished
						1: # defense
							Global.data_dict["player_defense_ratio"] *= (card.effect_num*multiple)
							Util.popup_dialogue(
								$Holder/DialogueHolder,
								["Your defense rose!"],
								["null"]
							)
							await Util.util_finished
					buff_applied = true
				3: #debuff
					print("debuff")
					match card.target_stat:
						0: # attack
							multiple = 1 + (1 - multiple)
							enemy_data.enemy_offense_ratio *= (card.effect_num*multiple)
							Util.popup_dialogue(
								$Holder/DialogueHolder,
								[enemy_data.enemy_name + "'s offense fell!"],
								["null"]
							)
							await Util.util_finished
						1: # defense
							multiple = 1 + (1 - multiple)
							enemy_data.enemy_defense_ratio *= (card.effect_num*multiple)
							Util.popup_dialogue(
								$Holder/DialogueHolder,
								[enemy_data.enemy_name + "'s defense fell!"],
								["null"]
							)
							await Util.util_finished
					buff_applied = true
			
			
	if multiple == 0.8:
		Util.popup_dialogue(
			$Holder/DialogueHolder,
			["It's not very effective..."],
			["null"]
		)
		await Util.util_finished
	elif multiple == 1.2:
		Util.popup_dialogue(
			$Holder/DialogueHolder,
			["It's super effective!"],
			["null"])
		await Util.util_finished
	
	if buff_applied:
		buff_applied = false
	else:
		print("Wiped buffs")
		Global.data_dict["player_offense_ratio"] = 1
		Global.data_dict["player_defense_ratio"] = 1
		enemy_data.enemy_offense_ratio = 1
		enemy_data.enemy_defense_ratio = 1
		
	enemy_data.enemy_hp = clamp(enemy_data.enemy_hp, 0, enemy_data.enemy_max_hp)
	enemy_data.enemy_mp = clamp(enemy_data.enemy_mp, 0, enemy_data.enemy_max_mp)
	Global.data_dict["player_hp"] = clamp(Global.data_dict["player_hp"], 0, Global.data_dict["player_max_hp"])
	Global.data_dict["player_mp"] = clamp(Global.data_dict["player_mp"], 0, Global.data_dict["player_max_mp"])
	refresh_stats()
	
	if enemy_data.enemy_hp <= 0:
		end_battle(true)
	elif Global.data_dict["player_hp"] <= 0:
		end_battle(false)
	else:
	
		await get_tree().create_timer(0.5).timeout
		
		if $EnemyData/Enemy.current_animation != "Idle":
			$EnemyData/Enemy.play("Idle")
		if $EnemyData/Player.current_animation != "Idle":
			$EnemyData/Player.play("Idle")
		
		emit_signal("card_action_finished")

func enemy_move():
	return enemy_data.get_best_card()

func refresh_stats():
	var a = create_tween()
	a.tween_property(
		$Holder/Player/BarHP, "value",
		Global.data_dict["player_hp"], 0.5).set_trans(Tween.TRANS_EXPO)
	a = create_tween()
	a.tween_property(
		$Holder/Player/BarMP, "value",
		Global.data_dict["player_mp"], 0.5).set_trans(Tween.TRANS_EXPO)
	a = create_tween()
	a.tween_property(
		$Holder/Opponent/BarHP, "value",
		enemy_data.enemy_hp, 0.5).set_trans(Tween.TRANS_EXPO)
	a = create_tween()
	a.tween_property(
		$Holder/Opponent/BarMP, "value",
		enemy_data.enemy_mp, 0.5).set_trans(Tween.TRANS_EXPO)

func end_battle(won : bool):
	match won:
		true:
			$EnemyData/Enemy.play("Damage")
		false:
			$EnemyData/Player.play("Damage")
	await get_tree().create_timer(0.5).timeout
	EffectAnim.play("FadeBlack")
	await EffectAnim.animation_finished
	if won: battle_result = "Victory!"
	else: battle_result = "Defeat..."
	end()
	# if you win you gain stats, if you lose you lose stats? idk
	
func flee_battle():
	battle_result = "Fled..."
	end()
	# no bonuses

func end():
	var stats_gained
	match battle_result:
		"Victory!":
			stats_gained = [5, 5, 5, 5]
		"Defeat...":
			stats_gained = [0, 0, 0, 0]
		"Fled...":
			stats_gained = [1, 1, 1, 1]
	await Util.create_reward_scene("SocialWarfare", [battle_result], stats_gained, self, $RewardHolder)
	get_tree().change_scene_to_file("res://scenes/menus/title.tscn")
	
func _process(delta):
	if shake_strength > 0:
		#print(shake_strength)
		cam.offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
		print(cam.offset)
		shake_strength -= shake_decay * delta
	
		
func start_shake(strength: float, decay: float):
	shake_strength = strength
	shake_decay = decay
