class_name LibraryMinigame extends Minigame

var started = false

var item_caught : Array[int] = [0, 0]

func _ready():
	await get_tree().create_timer(3).timeout
	$NPCInstancer.active = true
	$BookInstancer.active = true

#by default we gain and lose by 1 point. If we want to make some
#extra valuable books or damaging bombs, we can adjust that
#when calling the gain and lose points function

func gain_points(increment : int = 1):
	rough_points += increment
	update_points.emit(rough_points)
	update_item_caught("book")
	
func lose_points(decrease : int = 1):
	rough_points -= decrease
	update_points.emit(rough_points)
	update_item_caught("bomb")

func end():
	var stats_gained = compute_stats_gained(item_caught)
	detailed_points = [item_caught, stats_gained]
	emit_signal("minigame_finished", detailed_points)
	$LibraryPlayer/CollisionShape3D.disabled = true
	$LibraryPlayer.can_move = false
	#$NPCInstancer.queue_free()
	#$BookInstancer.queue_free()

func _on_library_player_book_collected():
	gain_points(1)
	if $LibraryPlayer/BookHolder.get_num_books() <= 20: 
		$LibraryPlayer/BookHolder.add_book_bone()

func _on_library_player_bomb_hit():
	lose_points(1)
	
func update_item_caught(item_type : String):
	match item_type:
		"book":
			item_caught[0] += 1
		"bomb":
			item_caught[1] += 1

func compute_stats_gained(item_caught):
	var int_gained = max(0, roundi(item_caught[0] * 0.3 - item_caught[1] * 0.1))
	var well_gained = max(0, roundi(item_caught[0] * 0.2 - item_caught[1] * 0.05))
	return [0, int_gained, 0, well_gained]
