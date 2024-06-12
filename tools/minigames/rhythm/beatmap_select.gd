extends Node3D

const DEBUG_POINT := preload('res://tools/minigames/rhythm/util/debug_point.tscn')
const BEATMAP_BUBBLE := preload('res://tools/minigames/rhythm/beatmap_bubble.tscn')
const RADIUS = 2.0

var is_ready := false
var theta := 0.0

var current_index := 0
var current_theta_offset := 0.0
var current_volume := 0.0
var has_chosen := false
var has_registered_input_this_frame := false
var current_beatmap : Beatmap

@export var beatmaps : Array[Beatmap] = [] : 
	set(value):
		beatmaps = value
		if is_ready: _reorient_bubbles()

func _ready() -> void:
	#EffectReg.start_effect(self, 'InteriorWarm', [$UI])
	_reorient_bubbles()
	_reset_preview()
	# FIXME: AAAAAAAAAAAAAAAAAA GODOT INPUT AAAAAAAAAA
	await get_tree().create_timer(0.1).timeout 
	is_ready = true
	
func _process(delta: float) -> void:
	current_beatmap = beatmaps[-current_index % len(beatmaps)]
	var target_theta_offset := float(current_index)*theta
	$UI/Label.text = current_beatmap.title
	if current_theta_offset != target_theta_offset:
		var diff : float = abs(current_theta_offset - target_theta_offset)
		current_theta_offset = move_toward(current_theta_offset, target_theta_offset, delta*pow(diff,0.7)*4.0);
		
		var bubbles := $Bubbles.get_children()
		for i in range(len(bubbles)):
			var phi = theta*i + PI*0.5 + current_theta_offset;
			var scale_factor = min(0.6, diff*0.2)
			bubbles[i].position = Vector3(RADIUS*cos(phi), bubbles[i].position.y, RADIUS*sin(phi))
			bubbles[i].scale = Vector3(1.0 + scale_factor*0.7, 1.0 - scale_factor, 1.0 + scale_factor*0.7)
	
	var volume_db = $AudioStreamPlayer.volume_db
	if not has_chosen and volume_db <= current_beatmap.volume_db_offset:
		$AudioStreamPlayer.volume_db = min(current_beatmap.volume_db_offset, move_toward(volume_db, 0.0, delta*abs(volume_db)*2.0));
		
	if has_chosen:
		$Camera3D.fov = move_toward($Camera3D.fov, 170, sqrt(100.0*delta))
		$AudioStreamPlayer.volume_db -= sqrt(100.0*delta)
		
	has_registered_input_this_frame = false

func _reorient_bubbles() -> void:
	for bubble in $Bubbles.get_children(): bubble.queue_free()
	
	theta = 2.0*PI / len(beatmaps)
	current_index = 0
	for i in range(len(beatmaps)):
		var phi = theta*i + PI*0.5;
		var bubble := BEATMAP_BUBBLE.instantiate()
		bubble.seed = beatmaps[i].title.hash()
		$Bubbles.add_child(bubble)
		bubble.preview_texture = beatmaps[i].preview
		bubble.position = Vector3(RADIUS*cos(phi), bubble.position.y, RADIUS*sin(phi))
		bubble.label.visible = i == 0

func _reset_preview() -> void:
	var beatmap := beatmaps[-current_index % len(beatmaps)]
	$AudioStreamPlayer.stream = beatmaps[-current_index % len(beatmaps)].track
	$AudioStreamPlayer.volume_db = -100.0
	$AudioStreamPlayer.play()
	$AudioStreamPlayer.seek(beatmap.preview_start)
	
	var duration := beatmap.objects[-1].time + beatmap.objects[-1].duration
	var difficulty := len(beatmap.objects)/(duration + 1e-8) # Difficulty is just note density LOL
	var description := 'Difficulty: %.2f★\nDuration: %d:%d' % [difficulty, int(duration / 60.0), int(duration) % 60]
	var bubbles := $Bubbles.get_children()
	for i in range(len(bubbles)):
		bubbles[i].label.visible = i == posmod(len(beatmaps) - current_index, len(beatmaps))
		bubbles[i].label.text = description

func _input(event: InputEvent) -> void:
	if not is_ready or has_chosen or has_registered_input_this_frame: return
	
	if event.is_action_pressed('ui_left'):
		_on_left_button_pressed()
	elif event.is_action_pressed('ui_right'):
		_on_right_button_pressed()
	elif event.is_action_pressed('ui_accept'):
		_on_select_button_pressed()
	has_registered_input_this_frame = true
		
func _on_left_button_pressed() -> void:
	current_index -= 1
	$SwitchTrackPlayer.play()
	$SwitchTrackPlayer2.play()
	_reset_preview()

func _on_right_button_pressed() -> void:
	current_index += 1
	$SwitchTrackPlayer.play()
	$SwitchTrackPlayer2.play()
	_reset_preview()

func _on_select_button_pressed() -> void:
	EffectReg.start_effect(self, 'ColorFade', [$UI, Color.TRANSPARENT, Color.WHITE, 0.2])
	has_chosen = true
	$SelectPlayer.play()
	$SelectPlayer2.play()
