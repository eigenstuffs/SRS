class_name PhysicsText extends Node2D

@onready var label : Label = $Label

@export var mass : float = 1.0
@export var force : Vector2 = Vector2(0, 5.0)
@export var time_scale : float = 2.0
@export var fake_torque : float = 0.1
@export var text : String = 'Lorem Ipsum'
@export var text_color : Color = Color(0,0,0)

@onready var velocity : Vector2 = force * (50 * time_scale) / mass

func _ready() -> void:
	label.text = self.text
	label.label_settings = label.label_settings.duplicate()
	label.label_settings.font_color = text_color

func _process(delta: float) -> void:
	force -= Vector2(0, 9.8)
	label.rotation += fake_torque * delta * time_scale
	velocity += force * (delta * time_scale) / mass # Add acceleration
	label.position -= velocity * (delta * time_scale) # Symplectic Euler

func _on_visibility_notifier_screen_exited() -> void:
	queue_free()
