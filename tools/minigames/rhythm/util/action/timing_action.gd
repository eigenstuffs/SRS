class_name TimingAction extends Resource

var time : float
var target : Variant

func _init(time_ : float, target_ : Variant) -> void:
	self.time = time_; self.target = target_

func run() -> void: pass
