extends TextureButton

@onready var original_pos = null

var card_data : Card

func _ready():
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)
	
func _on_mouse_entered():
	var a = create_tween()
	a.tween_property(self,
		"scale", Vector2(1.1, 1.1),
		0.05
	)
	a = create_tween()
	a.tween_property(self, "global_position",
	Vector2(original_pos.x - 10, original_pos.y - 60), 0.05)
	
	get_parent().move_child(self, -1)

func _on_mouse_exited():
	var a = create_tween()
	a.tween_property(self,
		"scale", Vector2(1, 1),
		0.05
	)
	a = create_tween()
	a.tween_property(self, "global_position",
	Vector2(original_pos.x, original_pos.y), 0.05)
