class_name LibraryMinigame extends Minigame

@onready var BOOK_CAUGHT_SFX = preload("res://tools/minigames/library/sound/book_caught.mp3")
@onready var SUBMIT_SFX = preload("res://tools/minigames/library/sound/submit_chime.mp3")
@onready var FINISHED_SFX = preload("res://tools/minigames/maze/sound/maze_game_finished.ogg")
@onready var EXPLOSION_SFX = preload("res://resources/effect/explosion_effect/explosion.mp3")

signal stop_blinking

var started = false
@export var player_health = 3
var item_caught : Array[int] = [0, 0]
var time := 0.0

func _process(delta: float) -> void:
	if not started: return
	time += delta
	var window_size := DisplayServer.window_get_size()
	if window_size.x > 1440 and is_playing and $ApplePlayer.get_playback_position() > 1.0:
		resize_window(Vector2i(lerpf(1920, 1440, min(($ApplePlayer.get_playback_position() - 1.0)*0.1, 1.0)), 1080))
	get_parent().get_parent().get_child(1).scale += Vector2.ONE * pow(time, 12.0) * 0.025

func resize_window(size : Vector2i) -> void:
	var diff := absf(DisplayServer.window_get_size().x - size.x) * 0.5
	$CanvasLayer2.offset.x += diff
	DisplayServer.window_set_size(size)
	DisplayServer.window_set_position(DisplayServer.window_get_position() + Vector2i(diff, 0))

var images : Array
var frames : Array
var hit_previously : Dictionary
var task_id : int

var previous_frame_idx := 0
var is_playing = false

func _physics_process(delta: float) -> void:
	if not started or time < 1.7: return
	if not is_playing:
		is_playing = true
		$ApplePlayer.play()
	
	var frame_idx := mini(len(frames) - 1, roundi($ApplePlayer.get_playback_position() * 30.0))
	if frame_idx == previous_frame_idx: return
	previous_frame_idx = frame_idx
	$CanvasLayer2/TextureRect.texture = images[frame_idx]
	
	var space_state = $Camera3D.get_world_3d().direct_space_state
	var excluded_objects = [$'Walls/Colliders/Back Wall', $'Walls/Colliders/Front Wall2',  $'Walls/Colliders/Right Wall',  $'Walls/Colliders/Left Wall']
	
	for hit_object in hit_previously.keys():
		hit_object.cover.set_instance_shader_parameter('white_factor', 0.0)
	hit_previously.clear()
	
	var frame_pixels = frames[frame_idx]
	for i in range(len(frame_pixels)):
		var ro = $Camera3D.project_ray_origin(frame_pixels[i][0])
		var rd = $Camera3D.project_ray_normal(frame_pixels[i][0])
		var query := PhysicsRayQueryParameters3D.create(ro, ro + rd*100, 0xFFFFFFFF, excluded_objects)
		var hit_info = space_state.intersect_ray(query)
		if hit_info.is_empty() or hit_previously.has(hit_info.collider) or not hit_info.collider is RBApple: continue
		hit_info.collider.cover.set_instance_shader_parameter('white_factor', frame_pixels[i][1])
		hit_previously[hit_info.collider] = null
		
		#var excluded_temp = [hit_info.collider]
		for j in range(5):
			ro = hit_info.position
			query = PhysicsRayQueryParameters3D.create(ro, ro + rd*100, 0xFFFFFFFF, [hit_info.collider])
			hit_info = space_state.intersect_ray(query)
			if hit_info.is_empty() or hit_previously.has(hit_info.collider) or not hit_info.collider is RBApple: break
			hit_info.collider.cover.set_instance_shader_parameter('white_factor', frame_pixels[i][1])
			hit_previously[hit_info.collider] = null
			#excluded_temp += [hit_info.collider]

func load_frames(frame_index):
	images[frame_index] = load(images[frame_index]).get_image() as Image
	print('Generated frame %d/%d!' % [frame_index, frames.size()-1])

func process_frames(frame_index):
	var image : Image = images[frame_index]
	var pixels : Array[Array]
	for i in range(0,image.get_width(),8):
		for j in range(0,image.get_height(),8):
			var col := 0.0
			#for i0 in range(8):
				#for j0 in range(8):
					#col += image.get_pixel(i+i0, j+j0).r
			col += image.get_pixel(i, j).r
			#col /= 8.0*8.0
			if col <= 0.01: continue
			
			var center := Vector2i(1440.0 * (i+4.0)/image.get_width() + 240.0, 1080.0 * (j+4.0)/image.get_height())
			pixels.push_back([center, col])
	frames[frame_index] = pixels
	images[frame_index] = ImageTexture.create_from_image(image)
	print('Processed frame %d/%d!' % [frame_index, frames.size()-1])

func _ready():
	var dir := DirAccess.open('res://tools/minigames/library/frames/')
	assert(dir)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.get_extension() == 'png':
			images.push_back('res://tools/minigames/library/frames/' + file_name)
		file_name = dir.get_next()
	images.sort_custom(func(a, b): return int(a) > int(b))
	frames.resize(images.size())
	task_id = WorkerThreadPool.add_group_task(load_frames, images.size(), 7)
	while not WorkerThreadPool.is_group_task_completed(task_id): await get_tree().create_timer(0.1).timeout # HAHAHAHA
	task_id = WorkerThreadPool.add_group_task(process_frames, images.size(), 2)
	started = true
	EffectReg.start_effect(self, 'Flash', [$EffectNode])
	$SfxPlayer.play()
	$SfxPlayer2.play()
	
func _exit_tree():
	WorkerThreadPool.wait_for_group_task_completion(task_id)

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
	if $LibraryPlayer/BookHolder.get_num_books() < 10: 
		$LibraryPlayer/BookHolder.add_book_bone(book)
		if $SfxPlayer.stream != FINISHED_SFX and $SfxPlayer.stream != SUBMIT_SFX:
			$SfxPlayer.stream = BOOK_CAUGHT_SFX
			$SfxPlayer.play()
	elif $LibraryPlayer/BookHolder.get_num_books() == 10:
		$Walls/Shelves.blinking()

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
	#if !EffectReg.effect_on:
		#$ExplosionPlayer.play()
		
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
		emit_signal("stop_blinking")

func music_fade_out():
	var a = create_tween()
	a.tween_property($MusicPlayer, "volume_db", -80, 2.0)
	await a.finished
	$MusicPlayer.stop()
	$MusicPlayer.volume_db = -8
