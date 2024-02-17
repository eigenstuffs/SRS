class_name RhythmPlayfield extends Node3D
## Works in conjunction with a initialized [class AudioSynchronizer] delegating
## beatmap hit objects to different keys and processing hit timing offsets.
##
## Will dynamically initialize an appropriate amount of [class RhythmKey [class AudioSynchronizer] members based on its own
## members.

const KEY = preload('res://tools/minigames/rhythm/play/key.tscn')
const PLAYFIELD_WIDTH = 8.0 # FIXME: No more fixed width please!

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
		# FIXME : Need more dynamic keybind system for more than 4 keys!
		match audio_synchronizer.beatmap.num_keys:
			4: key.keybind = {0: 'ui_left', 1: 'ui_down', 2: 'ui_up', 3: 'ui_right'}[key_index]
			7: key.keybind = {0: 'ui_left', 1: 'ui_left', 2: 'ui_down', 3: 'ui_accept', 4: 'ui_up', 5: 'ui_right', 6: 'ui_right'}[key_index]
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
			elif offset_ms < 100:
				print('(playfield) got score: great!   (%sms)' % offset_ms)
			elif offset_ms < 150:
				print('(playfield) got score: okay.    (%sms)' % offset_ms)
			else:
				print('(playfield) got score: bad      (%sms)' % offset_ms)
		Note.HitType.RELEASE:
			var offset_ms = abs(timing_offset*1e3)
			if offset_ms < 100:
				print('(playfield) got score: perfect! (%sms)' % offset_ms)
			elif offset_ms < 150:
				print('(playfield) got score: great!   (%sms)' % offset_ms)
			elif offset_ms < 200:
				print('(playfield) got score: okay.    (%sms)' % offset_ms)
			else:
				print('(playfield) got score: bad      (%sms)' % offset_ms)
		Note.HitType.MISS:
			print('(playfield) got score: missed!')
