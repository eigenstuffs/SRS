extends Node3D

const DEFAULT_PREVIEW_IMAGE := preload('res://tools/minigames/rhythm/default_beatmap_preview.png')

@export var preview_texture : CompressedTexture2D = DEFAULT_PREVIEW_IMAGE :
	set(value):
		preview_texture = value
		_set_preview_texture(value)
var seed := 0.0 : 
	set(value):
		seed = fmod(sin(value * 12.9898) * 43758.5453, 1.0) * 20.0

@onready var label : Label3D = $Label

func _ready() -> void:
	_set_preview_texture(DEFAULT_PREVIEW_IMAGE)

func _set_preview_texture(texture : CompressedTexture2D) -> void:
	$InnerBubble.set_surface_override_material(0, $InnerBubble.get_surface_override_material(0).duplicate())
	$InnerBubble.get_surface_override_material(0).set_shader_parameter('beatmap_texture', texture)

func _physics_process(delta: float) -> void:
	position.y = cos(seed + Time.get_ticks_msec()*1e-3*0.2) * 0.0425
