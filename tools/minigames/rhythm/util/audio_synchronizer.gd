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

@export var beatmap : Beatmap

## The offset for which the synchronizer will emit a signal to spawn the next
## hit object. For example, this can be used to spawn objects ahead of their
## assigned hit time so they could be moved.
@export var spawn_offset_seconds : float = 0.0

## Enables a ticking metronome sound on each beat of the track
@export var use_metronome : bool = false

@onready var track : AudioStreamPlayer = $Track
@onready var metronome : AudioStreamPlayer = $Metronome

var time : float
var next_metronome_time : float

var has_played : bool = false
var has_started := false
var object_idx : int = 0

func start():
	# Round time to nearest power of 2 multiple of bps
	self.time = -(2**(ceil(log(spawn_offset_seconds / self.beatmap.bps) / log(2))) * self.beatmap.bps)
	self.next_metronome_time = beatmap.start_offset + time
	track.stream = beatmap.track
	has_started = true

func _process(delta):
	if not has_started: return
	
	if has_played:
		# Source: https://docs.godotengine.org/en/stable/tutorials/audio/sync_with_audio.html
		time = max(time, track.get_playback_position() + AudioServer.get_time_since_last_mix())
	else:
		if time > -AudioServer.get_time_to_next_mix():
			track.play()
			#track.seek(40)
			has_played = true
		time += delta

	# Tick metronome ignoring output latency (since it calling play already includes it)
	if use_metronome and time >= next_metronome_time:
		next_metronome_time += self.beatmap.bps
		on_beat.emit()
		metronome.play()
