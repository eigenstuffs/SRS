class_name CallbackAction extends TimingAction

func _init(time_ : float, target_ : Callable, arguments : Array) -> void:
	super(time_, target_.bindv(arguments))

func run() -> void:
	target.call()
