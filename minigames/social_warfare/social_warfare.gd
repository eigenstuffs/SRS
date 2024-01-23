extends Control

@onready var MOVE_LIST = preload("res://minigames/social_warfare/SocialWarfareMoveList.tres")

@export var player_max_health : int # @export = edit in Inspector
@export var enemy_max_health : int # basically just for convenience

var player_health : int = -1 # we'll set these to max health by default
var enemy_health : int = -1

var intensity : int = 0

@onready var player_bar : ProgressBar = $CanvasLayer/HealthBars/PlayerHealth
@onready var enemy_bar : ProgressBar = $CanvasLayer/HealthBars/EnemyHealth
@onready var health_bars : Control = $CanvasLayer/HealthBars
@onready var player_moves : Control = $CanvasLayer/PlayerMoves
@onready var holder = $CanvasLayer/DialogueHolder

enum PLAYER_STATES {
	IDLE,
	LISTENING,
	TALK,
	ATTACK,
	DAMAGED
}

var PLAYER_STATE : PLAYER_STATES = PLAYER_STATES.IDLE

enum TURNS {
	PLAYER,
	ENEMY
}

var TURN : TURNS = TURNS.PLAYER

signal player_turn_completed
signal enemy_turn_completed
signal player_won
signal enemy_won
signal minigame_finished(player_won : bool)

func _ready():
	self.connect("player_won", player_wins)
	self.connect("enemy_won", enemy_wins)
	
	PLAYER_STATE = PLAYER_STATES.IDLE
	
	player_moves.hide()
	
	await get_tree().create_timer(0.3).timeout # wait 0.3 seconds
	
	## SET HEALTH
	
	player_health = player_max_health
	enemy_health = enemy_max_health
	
	## INITIALIZE HEALTH BARS
	
	player_bar.max_value = player_max_health
	enemy_bar.max_value = enemy_max_health
	
	# tweens are good for animations where you don't
	# know the starting and ending values
	
	# i also personally like using them for UI
	
	var a = create_tween()
	a.tween_property(player_bar, "value", player_health, 1).set_trans(Tween.TRANS_EXPO)
	a = create_tween() # Reset the tween to use it again
	a.tween_property(enemy_bar, "value", enemy_health, 1).set_trans(Tween.TRANS_EXPO)

	await a.finished # aka wait until the tween is finished
	
	turn_loop() # enter turn loop til one party wins
	
func turn_loop():
	if TURN == TURNS.PLAYER:
		PLAYER_STATE = PLAYER_STATES.IDLE
	
		## INITIALIZE MOVE BUTTONS
		
		var temp_move_list = MOVE_LIST.move_list.duplicate(true)
		
		# temporary move list so that we can sample w/o replacement
		
		for i in player_moves.get_children():
			if i is Button:
				temp_move_list.shuffle()
				var move = temp_move_list[0]
				i.apply_data(move)
				temp_move_list.erase(move) # dont wanna repeat
				# in case this isn't the first round
				if i.is_connected("move_selected", player_move_selected):
					i.disconnect("move_selected", player_move_selected)
				i.connect("move_selected", player_move_selected)
		health_bars.hide()
		player_moves.show() # make visible the buttons
		
		await player_turn_completed # wait for the player move
		
		TURN = TURNS.ENEMY # restart as enemy turn
		turn_loop()
		
	elif TURN == TURNS.ENEMY:
		PLAYER_STATE = PLAYER_STATES.LISTENING
		await get_tree().create_timer(1).timeout
		
		# this one is simpler as there's no UI necessary
		
		# pick the move
		var temp_move_list = MOVE_LIST.move_list.duplicate(true)
		temp_move_list.shuffle()
		var enemy_move = temp_move_list[0]
		
		Util.dialogue_from_strings(holder, enemy_move.move_text_enemy)
		await Util.util_finished
		
		# apply the damage
		var damage_done = randi_range(enemy_move.move_power - enemy_move.move_variance, enemy_move.move_power + enemy_move.move_variance)
		player_health -= damage_done
		
		# damage animation
		PLAYER_STATE = PLAYER_STATES.DAMAGED
		
		Util.dialogue_from_strings(holder, ["Opponent deals " + str(damage_done) + " damage!"])
		await Util.util_finished
		
		var a = create_tween()
		a.tween_property(player_bar, "value", player_health, 3).set_trans(Tween.TRANS_CUBIC)
		await a.finished
		
		# check if anyone lost
		if enemy_health <= 0: emit_signal("player_won")
		elif player_health <= 0: emit_signal("enemy_won")
		else:
			emit_signal("enemy_turn_completed")
			# switch the turns and restart
			TURN = TURNS.PLAYER
			turn_loop()
	else:
		print("something has gone horribly wrong")
		# game will crash here
	
func _process(_delta):
	anim_handler()

func anim_handler():
	match PLAYER_STATE:
		PLAYER_STATES.IDLE:
			$PlayerAnim.play("PlayerIdle")
			$EnemyAnim.play("EnemyIdle")
		PLAYER_STATES.LISTENING:
			$PlayerAnim.play("PlayerIdle")
			$EnemyAnim.play("EnemyTalk")
		PLAYER_STATES.TALK:
			$PlayerAnim.play("PlayerTalk")
			$EnemyAnim.play("EnemyIdle")
		PLAYER_STATES.ATTACK:
			$PlayerAnim.play("PlayerAttack")
			$EnemyAnim.play("EnemyDamaged")
		PLAYER_STATES.DAMAGED:
			$PlayerAnim.play("PlayerDamaged")
			$EnemyAnim.play("EnemyAttack")

func player_move_selected(move_resource : SocialWarfareMove):
	# hide the buttons
	player_moves.hide()
	health_bars.show()
	
	# update the animation
	PLAYER_STATE = PLAYER_STATES.TALK
	
	Util.dialogue_from_strings(holder, move_resource.move_text_player)
	await Util.util_finished
	
	# apply the move's damage
	var damage_done = randi_range(move_resource.move_power - move_resource.move_variance, move_resource.move_power + move_resource.move_variance)
	enemy_health -= damage_done
	
	# update/animate the health bar
	PLAYER_STATE = PLAYER_STATES.ATTACK
	
	Util.dialogue_from_strings(holder, ["You deal " + str(damage_done) + " damage!"])
	await Util.util_finished
	
	var a = create_tween()
	a.tween_property(enemy_bar, "value", enemy_health, 3).set_trans(Tween.TRANS_CUBIC)
	await a.finished
	
	# check to see if anyone won
	if enemy_health <= 0: emit_signal("player_won")
	elif player_health <= 0: emit_signal("enemy_won")
	
	# change the turn and restart the turn loop
	else: emit_signal("player_turn_completed")

func player_wins():
	Util.dialogue_from_strings(holder, ["You won!"])
	await Util.util_finished
	emit_signal("minigame_finished", true)
	
func enemy_wins():
	Util.dialogue_from_strings(holder, ["You lose!"])
	await Util.util_finished
	emit_signal("minigame_finished", false)
