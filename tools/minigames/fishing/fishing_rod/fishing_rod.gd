extends MeshInstance3D

signal fishing_starts
signal fishing_ends
signal fish_hooked
signal bobber_enter_water

@onready var moving_bobber : RigidBody3D = $MovingBobber
@onready var floating_bobber : RigidBody3D = $FloatingBobber
@onready var bobber = preload("res://tools/minigames/fishing/fishing_rod/floating_bobber.tscn")

var bobber_initial_v : Vector3 = Vector3(0, 5, 3)
var bobber_detached : bool = false
var retractable : bool = false
var last_state : bool = false

func _process(delta):
	if last_state != retractable:
		print("state changed from " + str(last_state) + " to " + str(retractable))
	last_state = retractable
	if Input.is_action_just_released("ui_accept") and retractable:
		retract_bobber()

func _on_fishing_player_fishing_time():
	if !bobber_detached:
		bobber_detached = true
		var b = bobber.instantiate()
		add_child(b)
		b.apply_central_impulse(bobber_initial_v)
		b.connect("water_entered", on_water_entered)
		emit_signal("fishing_starts")

func retract_bobber():
	for child in get_children():
		if child is FloatingBobber:
			child.queue_free()
	bobber_detached = false
	retractable = false
	emit_signal("fishing_ends")
	print("retracting")

func on_water_entered():
	retractable = true
	emit_signal("bobber_enter_water")
