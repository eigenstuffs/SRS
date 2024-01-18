extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayerAnim.play("PlayerIdle")
	$EnemyAnim.play("EnemyTalk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
