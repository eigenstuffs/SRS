class_name CardButton extends TextureButton

@onready var original_pos = null

signal chosen(data)

var card_data : Card

func _ready():
	await get_tree().create_timer(0.02).timeout
	reparent(get_parent().get_parent().get_node("Cards"))
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)
	
func _on_mouse_entered():
	var a = create_tween()
	a.tween_property(self,
		"scale", Vector2(1.1, 1.1),
		0.05
	)
	a = create_tween()
	a.tween_property($Elements, "global_position",
	Vector2(global_position.x - 10, global_position.y - 60), 0.05)
	
	get_parent().move_child(self, -1)

func _on_mouse_exited():
	var a = create_tween()
	a.tween_property(self,
		"scale", Vector2(1, 1),
		0.05
	)
	a = create_tween()
	a.tween_property($Elements, "global_position",
	Vector2(global_position.x, global_position.y), 0.05)

func _on_pressed():
	emit_signal("chosen", card_data)

func apply_assets():
	$Elements/Face.texture = card_data.image
	$Elements/Description.text = card_data.desc
	$Elements/Title.text = card_data.title
