class_name HitSlider extends HitNote

const NOTE = preload('res://tools/minigames/rhythm/note/note.tscn')
const TICK = preload('res://tools/minigames/rhythm/note/hit_slider/slider_tick.tscn')

@onready var aabb : AABB = $VisibilityNotifier.aabb
@onready var hitbox : Area3D = $Hitbox
@onready var collider : CollisionShape3D = hitbox.get_node('CollisionShape3D')
@onready var length : float = velocity.length() * duration_seconds
@onready var start_note : Note = spawn_note(0)
@onready var end_note : Note = spawn_note(-length)
@onready var body : HitSliderTick = TICK.instantiate()


func _ready() -> void:
	# We consider the length of the endpoint notes for collider
	self.collider.shape = collider.get_shape().duplicate()
	self.collider.shape.size.z = length + 0.1*2
	self.hitbox.position.z -= length / 2 # Offset by half of length
	self.aabb.size.z = -(length + 0.1*2)

	# Instantiate body members
	self.body.scale.z = length
	self.body.position += velocity.normalized() * -length*0.5
	self.body.key_position = key_position
	add_child(body)

	mesh = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta
	time += delta

func hit(z : float) -> float:
	return start_note.hit(z) if is_instance_valid(start_note) else 0.0

func hold(z : float) -> void:
	end_note.hold(z); body.hold(z)

func release(z : float) -> float:
	# Just delete the entire slider if the player let go too early
	queue_free()
	body.release(z); end_note.release(z)
	return end_note.hit(z)

func spawn_note(offset : float) -> Note:
	var note : Note = NOTE.instantiate()
	note.position += velocity.normalized() * offset
	note.key_position = key_position
	add_child(note)
	return note

func _on_visibility_notifier_screen_exited():
	queue_free()
