class_name HitSlider extends HitNote

const TICKS_PER_UNIT = 40
const NOTE = preload('res://tools/minigames/rhythm/note/note.tscn')
const TICK = preload('res://tools/minigames/rhythm/note/hit_slider/slider_tick.tscn')

var length : float
var spawn_delta : float
var tick_scale_z : float

var has_been_hit : bool = false
var next_tick_spawn_time : float = 0
var tick_spawn_offset_z : float = -0.1 * tick_scale_z
var tick_queue : Array = []
var total_ticks : float
var tick_index : int = 0

@onready var hitbox : Area3D = $Hitbox
@onready var collider : CollisionShape3D = hitbox.get_node('CollisionShape3D')
@onready var start_note : Note = spawn_note(0)
var end_note : Note

func _on_set_speed() -> void:
	self.length = speed * duration_seconds

	self.total_ticks = snappedi(length * TICKS_PER_UNIT, 1)
	self.spawn_delta = duration_seconds / total_ticks
	self.tick_scale_z = length / total_ticks / 0.2

	# We also consider the length of the endpoint notes
	collider.shape = collider.get_shape().duplicate()
	collider.shape.size.z = length + 0.1*2
	hitbox.position.z -= length / 2 # Offset by half of length

func hit(z : float) -> float:
	has_been_hit = true
	if is_instance_valid(start_note):
		return start_note.hit(z)
	return 0.0

func hold(z : float) -> void:
	if tick_queue.is_empty() or not has_been_hit: return

	if is_instance_valid(end_note) and z - end_note.global_position.z <= 0.1:
		end_note.visible = false

	# TODO: this doesn't need to be this reactive
	while !tick_queue.is_empty() and !is_instance_valid(tick_queue.front()):
		tick_queue.pop_front()
	while !tick_queue.is_empty() and z - tick_queue.front().global_position.z <= 0.001:
		tick_queue.pop_front().queue_free()

func release(z : float) -> float:
	queue_free()
	if is_instance_valid(end_note):
		return end_note.hit(z)
	return 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# TODO: stop this madness, just make a custom mesh :(
	if tick_index < total_ticks:
		while time - next_tick_spawn_time > -0.001:
			spawn_next_tick()
	elif not is_instance_valid(end_note):
		end_note = spawn_note(-length)

	position.z += speed * delta
	time += delta

func _on_visibility_notifier_screen_exited() -> void:
	queue_free()

func spawn_next_tick() -> void:
	tick_index += 1
	spawn_tick(tick_spawn_offset_z)
	next_tick_spawn_time += spawn_delta
	tick_spawn_offset_z -= 0.2 * tick_scale_z

func spawn_tick(offset_z : float) -> void:
	var tick : HitSliderTick = TICK.instantiate()
	$Ticks.add_child(tick)
	tick_queue.push_back(tick)
	tick.scale.z = tick_scale_z
	tick.position.z += offset_z

func spawn_note(offset_z : float) -> Note:
	var note : Note = NOTE.instantiate()
	$Ticks.add_child(note)
	note.position.z += offset_z
	return note
