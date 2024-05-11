class_name TimingPoint extends Resource

@export var start_time : float
@export var beat_interval : float
@export var beats_per_measure : int

func _init(start_time_ : float, beat_interval_ : float, beats_per_measure_ : int) -> void:
	self.start_time = start_time_
	self.beat_interval = beat_interval_
	self.beats_per_measure = beats_per_measure_
