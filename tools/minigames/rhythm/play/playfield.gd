class_name RhythmPlayfield extends Node3D
## Works in conjunction with a initialized [class AudioSynchronizer] delegating
## beatmap hit objects to different keys and processing hit timing offsets.
##
## Will dynamically initialize an appropriate amount of [class RhythmKey [class AudioSynchronizer] members based on its own
## members.

signal report_score(score: int)

const PHYSICS_TEXT = preload('res://tools/minigames/rhythm/util/physics_text.tscn')
const KEY = preload('res://tools/minigames/rhythm/play/key.tscn')
const PLAYFIELD_WIDTH : float = 8.0 # FIXME: No more fixed width please!
const RED : Color = Color(0.851, 0.184, 0.251)
const GREEN : Color = Color(0.424, 0.851, 0.475)
const BLUE : Color = Color(0.306, 0.796, 0.851)
# This is how we organize scoring for different millisecond offsets 
# (unless someone can come up with a better way!)
const HIT_SCORING = [
	[[0, 70], ['Perfect!', Color(0.231, 0.604, 1), 300*0.5]],
	[[70, 100], ['Great!', Color(0.31, 0.89, 0.369), 200*0.5]],
	[[100, 150], ['Okay.', Color(0.73, 0.58, 0.84), 100*0.5]],
	[[150, 1e9], ['Bad', Color(0.71, 0.565, 0.659), 50*0.5]]]
const RELEASE_SCORING = [
	[[0, 100], ['Perfect!', Color(0.231, 0.604, 1), 150*0.5]],
	[[100, 150], ['Great!', Color(0.31, 0.89, 0.369), 100*0.5]],
	[[150, 200], ['Okay.', Color(0.73, 0.58, 0.84), 50*0.5]],
	[[200, 1e9], ['Bad', Color(0.71, 0.565, 0.659), 25*0.5]]]

@export var beatmap : Beatmap
@export var note_speed : float = 2
@export var show_debug : bool = false

var keys : Array[RhythmKey] = []
var hit_objects : Array[HitObjectInfo]
var next_load_idx : int = 0
var next_timing_action_idx : int = 0
var beat : int = 0
var scores = [0, 0, 0, 0, 0]

@onready var audio_synchronizer : AudioSynchronizer = $AudioSynchronizer
@onready var screen_space_material : MultiPassShaderMaterial = $ScreenSpaceMesh.get_surface_override_material(0)
@onready var backplane_material : MultiPassShaderMaterial = $BackplaneMesh.get_surface_override_material(0)
# FIXME : Hardcoded for 'dungeon' beatmap!
@onready var timing_actions : Variant = WaltzMod.get_timing_actions(self) #DungeonMod.get_timing_actions(self) if beatmap.track.resource_path.get_file().trim_suffix('.' + beatmap.track.resource_path.get_extension()) == 'dungeon' else CaitSithMod.get_timing_actions(self) if beatmap.track.resource_path.get_file().trim_suffix('.' + beatmap.track.resource_path.get_extension()) == 'cait_sith' else WaltzMod.get_timing_actions(self) if beatmap.track.resource_path.get_file().trim_suffix('.' + beatmap.track.resource_path.get_extension()) == 'waltz' else []

func _ready() -> void:
	audio_synchronizer.spawn_offset_seconds = 1.0 # FIXME: Not static for all songs!
	audio_synchronizer.beatmap = self.beatmap
	self.hit_objects = beatmap.objects
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
			7: 
				key.keybind = 'rhythm_key_%d' % key_index
				key.note_color = [GREEN, BLUE, GREEN, RED, GREEN, BLUE, GREEN][key_index]
			_: assert(false, 'Playfield encountered an unsupported key count!')
		key.audio_synchronizer = audio_synchronizer
		key.scroll_time = 1.0 / note_speed
		
		key.connect('report_hit', _on_key_report_hit)
		keys.push_back(key)
		$Keys.add_child(key)
		
	$TitleLabel.text = beatmap.title

func start():
	audio_synchronizer.start()

func _process(_delta: float) -> void:
	if not audio_synchronizer.has_started: return
	
	# Compensate for output latency and spawn offset time.
	var corrected_time = audio_synchronizer.time - AudioServer.get_output_latency()
	while next_load_idx < len(hit_objects) and corrected_time + audio_synchronizer.spawn_offset_seconds > hit_objects[next_load_idx].time:
		var info := hit_objects[next_load_idx]
		keys[info.key_index].enqueue_note(info)
		next_load_idx += 1
		
	while next_timing_action_idx < len(timing_actions) and corrected_time > timing_actions[next_timing_action_idx].time:
		timing_actions[next_timing_action_idx].run()
		next_timing_action_idx += 1
		
func _physics_process(delta: float) -> void:

	$BPMLabel.visible = show_debug
	$FrametimeLabel.visible = show_debug
	$EnabledPassesLabel.visible = show_debug
	$BeatLabel.visible = show_debug
	if show_debug: 
		audio_synchronizer.use_metronome = true
		$BPMLabel.text = 'BPM: %.0f' % (audio_synchronizer.current_bps * 60.0)
		$FrametimeLabel.text = 'Frametime: %.3fms' % (Performance.get_monitor(Performance.TIME_PROCESS) * 1e3)
		$EnabledPassesLabel.text = 'Enabled Shader Passes:'
		for shader_name in MultiPassShaderMaterial.enabled_passes:
			$EnabledPassesLabel.text += '\n |  %s' % shader_name

func _on_key_report_hit(timing_offset : Variant, hit_type : Note.HitType):	
	var scoring = []
	match hit_type:
		Note.HitType.HIT:
			scoring = _get_scoring(abs(timing_offset*1e3), HIT_SCORING)
		Note.HitType.RELEASE:
			scoring = _get_scoring(abs(timing_offset*1e3), RELEASE_SCORING)
		Note.HitType.MISS:
			scoring = ['Missed!', Color(0.89, 0.25, 0.27), 0, -1]
	self.scores[scoring[-1]] += 1
	_create_score_text(scoring[0], scoring[1])
	report_score.emit(scoring[2])

func _get_scoring(timing_offset : float, scoring : Array):
	# Just so I can avoid the awful if..elif..elif.. chain...
	for i in range(len(scoring)):
		if scoring[i][0][0] <= timing_offset and timing_offset < scoring[i][0][1]:
			return scoring[i][1] + [i]
	printerr('A timing offset of %f could not be found in the provided scoring!' % timing_offset)
	return null

func _create_score_text(text : String, color : Color):
	var score : PhysicsText = PHYSICS_TEXT.instantiate()
	score.force = Vector2(randf_range(-0.75, 0.75), randf_range(5, 6.25))
	score.fake_torque = randf_range(-0.25, 0.25)
	score.text = text
	score.text_color = color
	score.position.x = randi_range(175, 275)
	add_child(score)

func _on_audio_synchronizer_on_beat() -> void:
	if not audio_synchronizer.has_started: return
	
	var time_int := floor(max(audio_synchronizer.time, 0.0)) as int
	var length := audio_synchronizer.track.stream.get_length() as int
	$BeatLabel.text = 'Beat: %d / %d  (%02d:%02d / %02d:%02d)' % [(beat % audio_synchronizer.current_beats_per_measure + 1), audio_synchronizer.current_beats_per_measure, (time_int / 60) % 60, time_int % 60, (length / 60) % 60, length % 60]
	beat += 1
