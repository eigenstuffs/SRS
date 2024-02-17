class_name RhythmKey extends Node3D
## Represents a single rhythm game 'key' bound to a single keybind.
##
## Responsible for registering/free()'ing notes within its scope as well as
## handling any note hits or misses (based on input or lack thereof).

class NoteQueue:
	var queue : Array[Note] = []
	
	func push(note : Note) -> void: 
		note.connect('tree_exiting', self.pop)
		queue.push_back(note)
		
	# Impl note: Notes must be free()'ed in the order they are pushed!
	func pop() -> Note:
		queue.front().disconnect('tree_exiting', self.pop)
		return queue.pop_front()
		
	func front() -> Note:
		return queue.front() if not queue.is_empty() else null

const HIT_NOTE = preload('res://tools/minigames/rhythm/hit_objects/note/hit_note.tscn')
const HIT_SLIDER = preload('res://tools/minigames/rhythm/hit_objects/slider/hit_slider.tscn')
const EARLY_HIT_WINDOW : float = 0.5 ## Maximum time early at which a note can be hit

## Reports the timing offset on hit/released status of a note. Returns `null`
## on a miss.
signal report_hit(timing_offset : Variant, hit_type : Note.HitType)

@export var keybind : String = 'ui_accept'
@export var audio_synchronizer : AudioSynchronizer
@export var scroll_time : float = 2.0
@export var release_window : float = 0.2 ## Time early/late at which a released note is considered 'hit'
@export var miss_window : float = 0.2 ## Time after note has paseed the key before consdering it 'miss'

var note_queue : NoteQueue = NoteQueue.new()
var corrected_time : float = -1 # Audio latency-corrected time

@onready var hit_sound : AudioStreamPlayer = $HitSoundPlayer
@onready var key_plane = $Editor/KeyPlane
@onready var spawn_position = $Editor/NoteSpawnPosition

func _ready() -> void:
	assert(audio_synchronizer, 'An `AudioSynchronizer` ref must be assigned before _ready()!')
	
func _process(delta: float) -> void:
	corrected_time = audio_synchronizer.time - AudioServer.get_output_latency()
	if not note_queue.front(): return
	
	# Handle note misses due to failing to release or never hitting at all.
	var next_note = note_queue.front()
	if not next_note.is_held and corrected_time - next_note.hit_time >= miss_window or \
			corrected_time - next_note.hit_time - next_note.duration >= release_window:
		register_hit(note_queue.pop(), Note.HitType.MISS, null)
	
func _input(event : InputEvent) -> void:
	if event.is_action_pressed(keybind): 
		hit_sound.play()
	if not note_queue.front(): return
	
	var next_note = note_queue.front()
	if event.is_action_pressed(keybind):
		var offset = next_note.hit_time - corrected_time
		if offset < EARLY_HIT_WINDOW: # Handle normal hit
			register_hit(next_note, Note.HitType.HIT, offset)
			
	elif event.is_action_released(keybind) and next_note.is_held:
		var offset = abs(next_note.hit_time + next_note.duration - corrected_time)
		if offset < release_window: # Handle normal release
			register_hit(next_note, Note.HitType.RELEASE, offset)
		else: # Handle early release
			register_hit(note_queue.pop(), Note.HitType.MISS, null)

func register_hit(note : Note, hit_type : Note.HitType, timing_offset : Variant) -> void:
	match hit_type:
		Note.HitType.HIT:     note.hit()
		Note.HitType.RELEASE: note.release()
		Note.HitType.MISS:    note.miss()
	report_hit.emit(timing_offset, hit_type)
	
func enqueue_note(info : BeatmapParser.ObjectInfo) -> void:
	var note : Note = HIT_SLIDER.instantiate() if info.is_slider else HIT_NOTE.instantiate()
	note.position = spawn_position.position
	note.timings_supplier = func() -> Array[float]: return [corrected_time, scroll_time] 
	note.spawn_point = spawn_position
	note.hit_point = key_plane
	note.hit_time = info.time
	note.duration = info.duration
		
	note_queue.push(note)
	$Notes.add_child(note)
