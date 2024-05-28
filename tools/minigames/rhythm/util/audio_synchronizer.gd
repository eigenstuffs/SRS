class_name AudioSynchronizer extends Node3D
## Audio latency-corrected osu! beatmap player.
##
## Based on the provided [AudioStream], [AudioSynchronizer] will
## search for a .osu beatmap of the respective name and parse it. Based on the
## parsed information, the BPM, start offset, and hit objects of the audio track
## will be precalculated and queued for signaling.
##
## Additionally, a beat-aligned rest time will be precalculated to ensure hit
## objects can be pre-spawned.

## Called on an interval of every BPS (e.g., when the metronome ticks)
signal on_beat

@export var beatmap : Beatmap : 
	set(value):
		beatmap = value
		self.current_beat_interval = self.beatmap.timings[0].beat_interval
		self.current_bps = 1.0 / self.current_beat_interval
		self.current_beats_per_measure = self.beatmap.timings[0].beats_per_measure

## The offset for which the synchronizer will emit a signal to spawn the next
## hit object. For example, this can be used to spawn objects ahead of their
## assigned hit time so they could be moved.
@export var spawn_offset_seconds : float = 0.0

@onready var track : AudioStreamPlayer = $Track
@onready var metronome : AudioStreamPlayer = $Metronome

var time : float
var next_metronome_time : float

var has_played : bool = false
var has_started := false
var timing_idx : int = 0
var current_bps : float = 0
var current_beat_interval : float = 0
var current_beats_per_measure : int = 4
var use_metronome := true

func start():	
	#beatmap.start_offset + x = current_beats_per_measure * 4 * current_beat_interval
	self.time = -((current_beats_per_measure - 1) * current_beat_interval) + beatmap.start_offset
	self.next_metronome_time = self.time
	track.stream = beatmap.track
	has_started = true

func _process(delta):
	if not has_started: return
	
	use_metronome = self.time <= beatmap.start_offset
	if has_played:
		# Source: https://docs.godotengine.org/en/stable/tutorials/audio/sync_with_audio.html
		time = max(time, track.get_playback_position() + AudioServer.get_time_since_last_mix())
	else:
		if time > -AudioServer.get_time_to_next_mix():
			track.play()
			#track.seek(40)
			has_played = true
		time += delta

	if timing_idx < len(beatmap.timings) and time >= beatmap.timings[timing_idx].start_time:
		var timing_point = self.beatmap.timings[timing_idx]
		current_beat_interval = timing_point.beat_interval
		current_bps = 1.0 / current_beat_interval
		current_beats_per_measure = timing_point.beats_per_measure
		next_metronome_time = timing_point.start_time
		timing_idx += 1

	# Tick metronome ignoring output latency (since it calling play already includes it)
	if time >= next_metronome_time:
		next_metronome_time += current_beat_interval
		on_beat.emit()
		
		if use_metronome: metronome.play()
