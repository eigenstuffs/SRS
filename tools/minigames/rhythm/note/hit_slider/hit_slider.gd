class_name HitSlider extends HitNote

const TICKS_PER_UNIT = 40
const NOTE = preload('res://tools/minigames/rhythm/note/note.tscn')
const TICK = preload('res://tools/minigames/rhythm/note/hit_slider/slider_tick.tscn')

var length : float
var tick_length : float

var has_been_hit : bool = false
var tick_queue : Array = []
var total_ticks : float

@onready var hitbox : Area3D = $Hitbox
@onready var collider : CollisionShape3D = hitbox.get_node('CollisionShape3D')
@onready var start_note : Note = spawn_note(0)
@onready var end_note : Note = spawn_note(-length)

func _ready() -> void:
	# We consider the length of the endpoint notes (must be set before ready)
	collider.shape = collider.get_shape().duplicate()
	collider.shape.size.z = length + 0.1*2
	hitbox.position.z -= length / 2 # Offset by half of length

	# TODO: stop this madness, just make a custom mesh :(
	var tick_start_offset : float = -0.1 * tick_length
	for i in range(total_ticks):
		spawn_tick(tick_start_offset - i*0.2*tick_length)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta
	time += delta

func hit(z : float) -> float:
	has_been_hit = true
	if is_instance_valid(start_note):
		return start_note.hit(z)
	return 0.0

func hold(z : float) -> void:
	if tick_queue.is_empty() or not has_been_hit: return

	if z - end_note.global_position.z <= 0.1:
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

func spawn_tick(offset : float) -> void:
	var tick : HitSliderTick = TICK.instantiate()
	tick.scale.z = tick_length
	tick.position += velocity.normalized() * offset
	tick.key_position = key_position

	$Ticks.add_child(tick)
	tick_queue.push_back(tick)

func spawn_note(offset : float) -> Note:
	var note : Note = NOTE.instantiate()
	note.position += velocity.normalized() * offset
	note.key_position = key_position

	$Ticks.add_child(note)
	return note

func _on_visibility_notifier_screen_exited() -> void:
	queue_free()

func _on_set_key_position(value : Vector3) -> void: pass

func _on_set_velocity() -> void:
	self.length = velocity.length() * duration_seconds
	self.total_ticks = snappedi(length * TICKS_PER_UNIT, 1)
	self.tick_length = length / total_ticks / 0.2
