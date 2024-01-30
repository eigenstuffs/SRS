extends Node
## Processes signals from an [class AudioSynchronizer] and spawns the respective
## hit objects.
##
## Will set the corresponding [class AudioSynchronizer] members based on its own
## members.

const HIT_NOTE = preload('res://tools/minigames/rhythm/note/hit_note/hit_note.tscn')
const HIT_SLIDER = preload('res://tools/minigames/rhythm/note/hit_slider/hit_slider.tscn')

@export var stream : AudioStream
@export var note_speed : float = 2

## The position at which notes should be spawned
@export var start_position_z = -1
## The position at which notes should be hit
@export var ending_position_z = 3.95

@onready var audio_synchronizer : AudioSynchronizer = $AudioSynchronizer

func _ready() -> void:
	audio_synchronizer.spawn_offset_seconds = (ending_position_z - start_position_z) / note_speed
	audio_synchronizer.stream = stream
	audio_synchronizer.start()

func spawn_note(info : BeatmapParser.ObjectInfo, offset_z : float) -> void:
	var note = HIT_SLIDER.instantiate() if info.is_slider else HIT_NOTE.instantiate()
	$Notes.add_child(note)
	note.global_position = Vector3(info.position, 0, offset_z)
	note.duration_seconds = info.duration_seconds
	note.speed = note_speed

func _on_audio_synchronizer_on_beatmap_object_spawn(info : BeatmapParser.ObjectInfo) -> void:
	spawn_note(info, start_position_z)
