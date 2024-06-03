class_name RhythmPlayfield extends Node3D
## Works in conjunction with a initialized [class AudioSynchronizer] delegating
## beatmap hit objects to different keys and processing hit timing offsets.
##
## Will dynamically initialize an appropriate amount of [class RhythmKey [class AudioSynchronizer] members based on its own
## members.

signal report_score(score: int)

const MEASURE_BAR = preload('res://tools/minigames/rhythm/play/hit_objects/measure_bar.tscn')
const PHYSICS_TEXT = preload('res://tools/minigames/rhythm/util/physics_text.tscn')
const KEY = preload('res://tools/minigames/rhythm/play/key.tscn')
const PLAYFIELD_WIDTH : float = 8.0 # FIXME: No more fixed width please!
const RED : Color = Color(0.851, 0.184, 0.251, 0.0)
const GREEN : Color = Color(0.424, 0.851, 0.475, 0.0)
const BLUE : Color = Color(0.306, 0.796, 0.851, 0.0)
# This is how we organize scoring for different millisecond offsets 
# (unless someone can come up with a better way!)
const HIT_SCORING = [
	[[0, 70], ['Perfect!', Color(0.231, 0.604, 1), 5]],
	[[70, 100], ['Great!', Color(0.31, 0.89, 0.369), 3]],
	[[100, 150], ['Okay.', Color(0.73, 0.58, 0.84), 1]],
	[[150, 1e9], ['Bad', Color(0.71, 0.565, 0.659), 0]]]
const RELEASE_SCORING = [
	[[0, 100], ['Perfect!', Color(0.231, 0.604, 1), 3]],
	[[100, 150], ['Great!', Color(0.31, 0.89, 0.369), 2]],
	[[150, 200], ['Okay.', Color(0.73, 0.58, 0.84), 1]],
	[[200, 1e9], ['Bad', Color(0.71, 0.565, 0.659), 0]]]

@export var beatmap : Beatmap
@export var note_speed : float = 2

var keys : Array[RhythmKey] = []
var hit_objects : Array[HitObjectInfo]
var next_load_idx : int = 0
var next_timing_action_idx : int = 0
var beat : int = 0
var scores = [0, 0, 0, 0, 0]
var measure_bar_key : RhythmKey
var combo := 0

@onready var audio_synchronizer : AudioSynchronizer = $AudioSynchronizer
@onready var screen_space_material : MultiPassShaderMaterial = $ScreenSpaceMesh.get_surface_override_material(0)
@onready var backplane_material : MultiPassShaderMaterial = $BackplaneMesh.get_surface_override_material(0)
# FIXME : Hardcoded for 'dungeon' beatmap!
@onready var timing_actions : Variant
@onready var effects : Control = $Effects

func prepare():
	audio_synchronizer.beatmap = self.beatmap
	self.hit_objects = beatmap.objects
	self.timing_actions = beatmap.mod_file.get_timing_actions(self) if beatmap.mod_file else []
	print('(playfield) initialized audio synchronizer')
	
	# Initialize keys based on key count of beatmap
	var num_keys : int = beatmap.num_keys
	for key_index in range(num_keys):
		var key : RhythmKey = KEY.instantiate()
		key.position.x = (-0.5 + key_index / (num_keys - 1.0)) * (num_keys + (1.0/6.0 * (num_keys - 1.0)))
		# FIXME: I thought we were supposed to stick to the built-in input mappings!
		# FIXME: Also this is a bad way to map keybinds and note colors!
		match num_keys:
			4:
				key.keybind = 'rhythm_key_%d' % [1, 2, 4, 5][key_index]
				key.note_color = [GREEN, BLUE, BLUE, GREEN][key_index]
				key.note_angle = deg_to_rad([180, 270, 90, 0][key_index])
			7: 
				key.keybind = 'rhythm_key_%d' % key_index
				key.note_color = [GREEN, BLUE, GREEN, RED, GREEN, BLUE, GREEN][key_index]
			_: assert(false, 'Playfield encountered an unsupported key count!')
		key.audio_synchronizer = audio_synchronizer
		key.scroll_time = 1.0 / note_speed
		
		key.connect('report_hit', _on_key_report_hit)
		keys.push_back(key)
		$Keys.add_child(key)
	
	# A special (unusable) key will also be created for spawning measure bars
	measure_bar_key = KEY.instantiate()
	measure_bar_key.keybind = ''
	measure_bar_key.audio_synchronizer = audio_synchronizer
	measure_bar_key.scroll_time = 1.0 / note_speed
	measure_bar_key.is_visible = false
	$Keys.add_child(measure_bar_key)
		
	$TitleLabel.text = beatmap.title

func start():
	audio_synchronizer.start()

func _process(_delta: float) -> void:
	if not audio_synchronizer.has_started: return
	
	# Compensate for output latency and spawn offset time.
	var corrected_time = audio_synchronizer.time - AudioServer.get_output_latency()
	const SPAWN_OFFSET_SECONDS := 1.0
	while next_load_idx < len(hit_objects) and corrected_time + SPAWN_OFFSET_SECONDS > hit_objects[next_load_idx].time:
		var info := hit_objects[next_load_idx]
		keys[info.key_index].enqueue_note(info)
		next_load_idx += 1
		
	while next_timing_action_idx < len(timing_actions) and corrected_time > timing_actions[next_timing_action_idx].time:
		timing_actions[next_timing_action_idx].run()
		next_timing_action_idx += 1

func _on_key_report_hit(timing_offset : Variant, hit_type : Note.HitType):	
	var scoring = []
	match hit_type:
		Note.HitType.HIT:
			scoring = _get_scoring(abs(timing_offset*1e3), HIT_SCORING)
			_update_combo(combo + 1, scoring[0], scoring[1])
		Note.HitType.RELEASE:
			scoring = _get_scoring(abs(timing_offset*1e3), RELEASE_SCORING)
			_update_combo(combo + 1, scoring[0], scoring[1])
		Note.HitType.MISS:
			scoring = ['Missed!', Color(0.89, 0.25, 0.27), 0, -1]
			_update_combo(0, scoring[0], scoring[1])
	self.scores[scoring[-1]] += 1
	report_score.emit(scoring[2])

func _update_combo(new_combo : int, new_score : String, score_color : Color) -> void:
	if new_combo > combo:
		pass
	else: # Missed
		pass
	$Scores.update_combo_text(new_combo)
	$Scores.update_score_text(new_score, score_color)
	combo = new_combo

func _get_scoring(timing_offset : float, scoring : Array):
	# Just so I can avoid the awful if..elif..elif.. chain...
	for i in range(len(scoring)):
		if scoring[i][0][0] <= timing_offset and timing_offset < scoring[i][0][1]:
			return scoring[i][1] + [i]
	printerr('A timing offset of %f could not be found in the provided scoring!' % timing_offset)
	return null

func _on_audio_synchronizer_on_beat() -> void:
	beat += 1
	
	if beat % audio_synchronizer.current_beats_per_measure != 0 or audio_synchronizer.time < 0 or not measure_bar_key: 
		return
	
	var note : MeasureBar = MEASURE_BAR.instantiate()
	note.position = measure_bar_key.spawn_position.position
	note.timings_supplier = func() -> Array[float]: return [measure_bar_key.corrected_time, 1.0 / note_speed] 
	note.spawn_point = measure_bar_key.spawn_position
	note.hit_point = measure_bar_key.key_plane
	note.hit_time = measure_bar_key.corrected_time + audio_synchronizer.current_beat_interval*4
	note.duration = audio_synchronizer.current_beat_interval*4
		
	measure_bar_key.note_queue.push(note)
	measure_bar_key.add_child(note)
