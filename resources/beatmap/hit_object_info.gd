class_name HitObjectInfo extends Resource

@export var time : float
@export var key_index : float
@export var is_slider : bool
@export var duration : float

func _init(time_, key_index_, is_slider_, duration_):
	self.time = time_; self.key_index = key_index_; self.is_slider = is_slider_; self.duration = duration_
