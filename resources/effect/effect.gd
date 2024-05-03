class_name Effect extends Resource

## Signaled when the effect has finished running (according to [member duration])
signal finished
## Signaled if the effect was started while it was already running
signal interrupted

@export var name : String
## The duration the effect in seconds. A duration time of 0 indicates that the 
## effect does not end automatically.
@export var duration := 0.0

## Called before timer logic is set up, `duration` should be modified here if needed.
var on_start : Callable
		
var on_stop : Callable

var on_queue_free : Callable

var should_free_when_stopped := false
var timer : Timer

func _init(name_ := 'NO_NAME', duration_ := 0.0, on_start_ := func(): pass, on_stop_ := func(): pass, on_queue_free_ := func(): pass) -> void:
	self.name = name_
	self.duration = duration_
	self.on_start = on_start_
	self.on_stop = on_stop_
	self.on_queue_free = on_queue_free_

## Starts the effect calling [member on_run] supplied with the provided arguments.
## If called while the effect is already running, it will restart.
func start(args : Array=[]) -> void:
	on_start.callv(args)
	if not timer: 
		timer = Timer.new()
		timer.connect('timeout', stop if self.duration != 0 else func(): pass) # FIXME: ew!
		timer.wait_time = self.duration + 0.000001 # FIXME: ew!
		timer.autostart = true
		timer.one_shot = true
	else:
		timer.start(self.duration)
		interrupted.emit()
	
func stop() -> void:
	if on_stop: on_stop.call()
	finished.emit()
	
	if should_free_when_stopped:
		queue_free()
	elif is_instance_valid(timer): 
		timer.queue_free()

func queue_free() -> void:
	if on_queue_free: on_queue_free.call()
	if is_instance_valid(timer): timer.queue_free()
