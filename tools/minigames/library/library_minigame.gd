class_name LibraryMinigame extends Minigame

@onready var BOOK_CAUGHT_SFX = preload("res://tools/minigames/library/sound/book_caught.mp3")
@onready var SUBMIT_SFX = preload("res://tools/minigames/library/sound/submit_chime.mp3")
@onready var FINISHED_SFX = preload("res://tools/minigames/maze/sound/maze_game_finished.wav")

signal stop_blinking

var started = false
@export var player_health = 3
var item_caught : Array[int] = [0, 0]

func _ready():
	pass

func game_start():
	$NPCInstancer.active = true
	$BookInstancer.active = true
#by default we gain and lose by 1 point. If we want to make some
#extra valuable books or damaging bombs, we can adjust that
#when calling the gain and lose points function

func gain_points(increment : int = 1):
	rough_points += increment
	update_points.emit(rough_points)
	update_item_caught("book", increment)
	
func lose_points(decrease : int = 1):
	update_item_caught("bomb", decrease)

func end():
	$LibraryPlayer.can_move = false
	$NPCInstancer.active = false
	$BookInstancer.active = false
	music_fade_out()
	$SfxPlayer.stream = FINISHED_SFX
	$SfxPlayer.volume_db = 5
	$SfxPlayer.play()
	var stats_gained = compute_stats_gained(item_caught)
	detailed_points = [item_caught, stats_gained]
	emit_signal("ended")
	await $SfxPlayer.finished
	emit_signal("minigame_finished", detailed_points)
	$LibraryPlayer/CollisionShape3D.disabled = true
	$LibraryPlayer.can_move = false
	#$NPCInstancer.queue_free()
	#$BookInstancer.queue_free()

func _on_library_player_book_collected(book : Book):
	#if $LibraryPlayer/BookHolder.get_num_books() == 0:
		#$Walls/Shelves.blinking()
	if $LibraryPlayer/BookHolder.get_num_books() < 10: 
		$LibraryPlayer/BookHolder.add_book_bone(book)
		if $SfxPlayer.stream != FINISHED_SFX:
			$SfxPlayer.stream = BOOK_CAUGHT_SFX
			$SfxPlayer.play()
	elif $LibraryPlayer/BookHolder.get_num_books() == 10:
		EffectReg.start_effect(self, "Vignette", [$EffectNode])

func _on_library_player_bomb_hit(bomb : Bomb):
	lose_points(1)
	$LibraryPlayer.can_move = false
	$LibraryPlayer.hurt = true
	$LibraryPlayer/BookHolder.clear_all_books()
	$LibraryPlayer.move_hurtbox()
	$CanvasLayer.remove_heart()
	emit_signal("stop_blinking")
	#EffectReg.start_effect(self, "Flash", [$E])
	player_health -= 1
	do_explosion(bomb)
	bomb.queue_free()
	if player_health == 0:
		$LibraryPlayer.hurt = false
		$LibraryPlayer.fail = true
		await get_tree().create_timer(0.4, true, false, true).timeout
		end()
	else:
		await get_tree().create_timer(0.3).timeout
		$LibraryPlayer.hurt = false
		$LibraryPlayer.can_move = true
		
func do_explosion(bomb : Bomb): 
	var bomb_position := bomb.rigid_body.global_position
	EffectReg.start_effect(self, 'Explosion', [self, EffectReg, bomb_position])
		
	for obj in $BookInstancer.get_children().slice(1):
		if obj == bomb: continue
		var rigidbody : RigidBody3D = obj.rigid_body
		var impulse_direction := rigidbody.global_position - bomb_position
		impulse_direction.y = minf(impulse_direction.y, 0.02) # Limit vertical force
		rigidbody.freeze = false
		rigidbody.apply_central_impulse(impulse_direction.normalized() * 0.1)
	
func update_item_caught(item_type : String, increment : int):
	match item_type:
		"book":
			item_caught[0] += increment
		"bomb":
			item_caught[1] += increment

func compute_stats_gained(item_caught):
	var int_gained = max(0, roundi(item_caught[0] * 0.3 - item_caught[1] * 0.1))
	var well_gained = max(0, roundi(item_caught[0] * 0.2 - item_caught[1] * 0.05))
	return [0, int_gained, 0, well_gained]

func _on_bookshelf_player_entered():
	var num_of_books = $LibraryPlayer/BookHolder.get_num_books()
	if num_of_books > 0:
		$SfxPlayer.stream = SUBMIT_SFX
		$SfxPlayer.play()
		gain_points(num_of_books)
		emit_signal("update_time", num_of_books)
		$LibraryPlayer/BookHolder.clear_all_books()
		$LibraryPlayer.move_hurtbox()

func _physics_process(_delta: float) -> void:
	RenderingServer.global_shader_parameter_set('cpu_sync_time', Time.get_ticks_usec()*1e-6)

func music_fade_out():
	var a = create_tween()
	a.tween_property($MusicPlayer, "volume_db", -80, 2.0)
	await a.finished
	$MusicPlayer.stop()
	$MusicPlayer.volume_db = -8
