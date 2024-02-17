class_name AudioSynchronizer extends Node3D
## Audio latency-corrected .osu beatmap player.
##
## Based on the provided [class AudioStream], [class AudioSynchronizer] will
## search for a .osu beatmap of the respective name and parse it. Based on the
## parsed information, the BPM, start offset, and hit objects of the audio track
## will be precalculated and queued for signaling.
##
## Additionally, a beat-aligned rest time will be precalculated to ensure hit
## objects can be pre-spawned.

## Called on an interval of every BPS (e.g., when the metronome ticks)
signal on_beat

@export var stream : AudioStream

## The path to the .osu file to read. If not set, the name of the stream resource
## path will be used.
@export var beatmap_path : String

## The offset for which the synchronizer will emit a signal to spawn the next
## hit object. For example, this can be used to spawn objects ahead of their
## assigned hit time so they could be moved.
@export var spawn_offset_seconds : float = 0.0

## Enables a ticking metronome sound + respective UI element
@export var use_metronome : bool = false

@onready var track : AudioStreamPlayer = $Track
@onready var metronome : AudioStreamPlayer = $Metronome
@onready var bpm_text : Label = $BPMLabel

var time : float
var corrected_time : float # Audio latency-corrected time
var next_metronome_time : float

var has_played : bool = false
var beat : int = 0
var object_idx : int = 0
var beatmap : BeatmapParser.Beatmap

func start():
	assert(stream.resource_path.ends_with('.mp3'), 'Stream resource must be an .mp3 file!')
	self.beatmap_path = beatmap_path if beatmap_path else '%s.osu' % stream.resource_path.trim_suffix('.mp3')
	self.beatmap = BeatmapParser.load(beatmap_path)

	# Round time to nearest power of 2 multiple of bps
	self.time = -(2**(ceil(log(spawn_offset_seconds / self.beatmap.bps) / log(2))) * self.beatmap.bps)
	self.next_metronome_time = beatmap.start_offset + time
	track.stream = stream

func _process(delta):
	if has_played:
		# Source: https://docs.godotengine.org/en/stable/tutorials/audio/sync_with_audio.html
		time = track.get_playback_position() + AudioServer.get_time_since_last_mix()
	else:
		if time > -AudioServer.get_time_to_next_mix():
			track.play()
			has_played = true
		time += delta

	# Tick metronome ignoring output latency (since it calling play already includes it)
	if use_metronome and time >= next_metronome_time:
		bpm_text.visible = true
		bpm_text.text = '%d / 4' % (beat % 4 + 1) # TODO: 4/4 time only lmao
		beat += 1
		next_metronome_time += self.beatmap.bps
		on_beat.emit()
		metronome.play()
