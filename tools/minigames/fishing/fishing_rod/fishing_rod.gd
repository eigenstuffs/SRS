extends MeshInstance3D

signal fishing_starts
signal fishing_ends

@onready var bobber : RigidBody3D = $Bobber

var bobber_initial_v : Vector3 = Vector3(0, 5, 3)
var bobber_detached : bool = false
var bobber_pos

func _ready():
	bobber_pos = bobber.transform
	bobber.visible = false

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if !bobber_detached:
			bobber_detached = true
			bobber.transform = bobber_pos
			bobber.visible = true
			bobber.launch(bobber_initial_v)
			emit_signal("fishing_starts")
		elif bobber.is_in_water:
			bobber_detached = false
			bobber.transform = bobber_pos
			bobber.visible = false
			emit_signal("fishing_ends")
