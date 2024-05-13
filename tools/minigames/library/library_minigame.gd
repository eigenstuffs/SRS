class_name LibraryMinigame extends Minigame

var started = false
@export var player_health = 3
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
	emit_signal("ended")
	emit_signal("minigame_finished", detailed_points)
	$LibraryPlayer/CollisionShape3D.disabled = true
	$LibraryPlayer.can_move = false
	#$NPCInstancer.queue_free()
	#$BookInstancer.queue_free()

func _on_library_player_book_collected(book : Book):
	#gain_points(1)
	if $LibraryPlayer/BookHolder.get_num_books() < 10: 
		$LibraryPlayer/BookHolder.add_book_bone(book)
	elif $LibraryPlayer/BookHolder.get_num_books() == 10:
		EffectRegistry.start_effect(self, "Vignette", [$EffectNode])

func _on_library_player_bomb_hit(bomb : Bomb):
	$LibraryPlayer/BookHolder.clear_all_books()
	$LibraryPlayer.move_hurtbox()
	$CanvasLayer.remove_heart()
	#EffectRegistry.start_effect(self, "Flash", [$E])
	player_health -= 1
	if player_health == 0:
		$LibraryPlayer.can_move = false
		await get_tree().create_timer(0.4, true, false, true).timeout
		end()
	do_explosion(bomb)
	bomb.queue_free()
		
func do_explosion(bomb : Bomb): 
	var bomb_position := bomb.rigid_body.global_position
	EffectRegistry.start_effect(self, 'Explosion', [self, EffectRegistry, bomb_position])
		
	for obj in $BookInstancer.get_children().slice(1):
		if obj == bomb: continue
		var rigidbody : RigidBody3D = obj.rigid_body
		var impulse_direction := rigidbody.global_position - bomb_position
		impulse_direction.y = minf(impulse_direction.y, 0.02) # Limit vertical force
		rigidbody.freeze = false
		rigidbody.apply_central_impulse(impulse_direction.normalized() * 0.1)
	
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

func _on_bookshelf_player_entered():
	var num_of_books = $LibraryPlayer/BookHolder.get_num_books()
	gain_points(num_of_books)
	emit_signal("update_time", num_of_books)
	$LibraryPlayer/BookHolder.clear_all_books()
	$LibraryPlayer.move_hurtbox()

func _physics_process(_delta: float) -> void:
	RenderingServer.global_shader_parameter_set('cpu_sync_time', Time.get_ticks_usec()*1e-6)
