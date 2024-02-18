class_name RhythmPlayfield extends Node3D
## Works in conjunction with a initialized [class AudioSynchronizer] delegating
## beatmap hit objects to different keys and processing hit timing offsets.
##
## Will dynamically initialize an appropriate amount of [class RhythmKey [class AudioSynchronizer] members based on its own
## members.

const PHYSICS_TEXT = preload('res://tools/minigames/rhythm/util/physics_text.tscn')
const KEY = preload('res://tools/minigames/rhythm/play/key.tscn')
const PLAYFIELD_WIDTH : float = 8.0 # FIXME: No more fixed width please!
const RED : Color = Color(0.851, 0.184, 0.251)
const GREEN : Color = Color(0.424, 0.851, 0.475)
const BLUE : Color = Color(0.306, 0.796, 0.851)

@export var stream : AudioStream
@export var note_speed : float = 2

@onready var audio_synchronizer : AudioSynchronizer = $AudioSynchronizer

var keys : Array[RhythmKey] = []
var hit_objects : Array[BeatmapParser.ObjectInfo]
var next_load_idx : int = 0

func _ready() -> void:
	audio_synchronizer.spawn_offset_seconds = 2.0
	audio_synchronizer.stream = stream
	audio_synchronizer.start()
	self.hit_objects = audio_synchronizer.beatmap.objects
	print('(playfield) initialized audio synchronizer')
	
	# Initialize keys based on key count of beatmap
	for key_index in range(audio_synchronizer.beatmap.num_keys):
		var key : RhythmKey = KEY.instantiate()
		key.position.x = (-0.5 + key_index / (audio_synchronizer.beatmap.num_keys - 1.0))*PLAYFIELD_WIDTH
		# FIXME: I thought we were supposed to stick to the built-in input mappings!
		match audio_synchronizer.beatmap.num_keys:
			4:
				key.keybind = 'rhythm_key_%d' % key_index
				key.note_color_overwrite = [GREEN, BLUE, BLUE, GREEN][key_index]
			7: 
				key.keybind = 'rhythm_key_%d' % key_index
				key.note_color_overwrite = [GREEN, BLUE, GREEN, RED, GREEN, BLUE, GREEN][key_index]
			_: assert(false, 'Playfield encountered an unsupported key count!')
		key.audio_synchronizer = audio_synchronizer
		key.scroll_time = 1.0 / note_speed
		
		key.connect('report_hit', _on_key_report_hit)
		keys.push_back(key)
		$Keys.add_child(key)

func _process(delta: float) -> void:
	# Compensate for output latency and spawn offset time.
	var spawn_time = audio_synchronizer.time - AudioServer.get_output_latency() + audio_synchronizer.spawn_offset_seconds
	while next_load_idx < len(self.hit_objects) and spawn_time > self.hit_objects[next_load_idx].time:
		var info : BeatmapParser.ObjectInfo = self.hit_objects[next_load_idx]
		keys[info.key_index].enqueue_note(info)
		next_load_idx += 1

func _on_key_report_hit(timing_offset : Variant, hit_type : Note.HitType):
	# FIXME: bruh.
	match hit_type:
		Note.HitType.HIT:
			var offset_ms = abs(timing_offset*1e3)
			if offset_ms < 70:
				print('(playfield) got score: perfect! (%sms)' % offset_ms)
				create_score_text('Perfect!', Color(0.231, 0.604, 1))
			elif offset_ms < 100:
				print('(playfield) got score: great!   (%sms)' % offset_ms)
				create_score_text('Great!', Color(0.31, 0.89, 0.369))
			elif offset_ms < 150:
				print('(playfield) got score: okay.    (%sms)' % offset_ms)
				create_score_text('Okay.', Color(0.73, 0.58, 0.84))
			else:
				print('(playfield) got score: bad      (%sms)' % offset_ms)
				create_score_text('Bad', Color(0.71, 0.565, 0.659))
		Note.HitType.RELEASE:
			var offset_ms = abs(timing_offset*1e3)
			if offset_ms < 100:
				print('(playfield) got score: perfect! (%sms)' % offset_ms)
				create_score_text('Perfect!', Color(0.231, 0.604, 1))
			elif offset_ms < 150:
				print('(playfield) got score: great!   (%sms)' % offset_ms)
				create_score_text('Great!', Color(0.31, 0.89, 0.369))
			elif offset_ms < 200:
				print('(playfield) got score: okay.    (%sms)' % offset_ms)
				create_score_text('Okay.', Color(0.73, 0.58, 0.84))
			else:
				print('(playfield) got score: bad      (%sms)' % offset_ms)
				create_score_text('Bad', Color(0.71, 0.565, 0.659))
		Note.HitType.MISS:
			print('(playfield) got score: missed!')
			create_score_text('Missed!', Color(0.89, 0.25, 0.27))

func create_score_text(text : String, color : Color):
	var score : PhysicsText = PHYSICS_TEXT.instantiate()
	score.force = Vector2(randf_range(-0.75, 0.75), randf_range(5, 6.25))
	score.fake_torque = randf_range(-0.25, 0.25)
	score.text = text
	score.text_color = color
	score.position.x = randi_range(125, 225)
	add_child(score)
