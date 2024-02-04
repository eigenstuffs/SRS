class_name LibraryMinigame extends Minigame

var started = false

func _ready():
	await get_tree().create_timer(3).timeout
	$NPCInstancer.active = true
	$BookInstancer.active = true

#by default we gain and lose by 1 point. If we want to make some
#extra valuable books or damaging bombs, we can adjust that
#when calling the gain and lose points function

func gain_points(increment : int = 1):
	points += increment
	update_points.emit(points)
	
func lose_points(decrease : int = 1):
	points -= decrease
	update_points.emit(points)

func end():
	emit_signal("minigame_finished", points)
	$LibraryPlayer/CollisionShape3D.disabled = true
	$LibraryPlayer.can_move = false
	$NPCInstancer.queue_free()
	$BookInstancer.queue_free()
	print(points)

func _on_library_player_book_collected():
	gain_points(1)
	if $LibraryPlayer/BookHolder.get_num_books() <= 20: 
		$LibraryPlayer/BookHolder.add_book_bone()

func _on_library_player_bomb_hit():
	lose_points(1)
