class_name Effect extends Resource

## Signaled when the effect has finished running (according to [member duration])
signal finished
## Signaled if the effect was started while it was already running
signal interrupted

@export var name : String
## The duration the effect in seconds. A duration time of 0 indicates that the 
## effect does not end automatically. Not thread-safe!
@export var duration := 0.0 :
	set(value):
		if self.is_running:
			printerr('An attempt to change effect %s duration was made, but duration cannot be " + \
				"changed while the effect is running!' % self.name)
			return
		duration = value

@export var on_start : Callable = func(): pass :
	set(value):
		assert(not self.is_running)
		on_start = value
		
@export var on_stop : Callable = func(): pass

var is_running := false
var timer : Timer
	
## Starts the effect calling [member on_run] supplied with the provided arguments.
## If called while the effect is already running, it will restart.
func start(args : Array=[]) -> void:
	if not timer: 
		timer = Timer.new()
		timer.connect('timeout', stop if self.duration != 0 else func(): pass) # FIXME: ew!
		timer.wait_time = self.duration + 0.000001 # FIXME: ew!
		timer.autostart = true
		timer.one_shot = true
	else:
		timer.start(self.duration)
		interrupted.emit()
	
	on_start.callv(args)
	is_running = true
	
func stop() -> void:
	if is_instance_valid(timer): timer.queue_free()
	finished.emit()
	
	on_stop.call()
	is_running = false
