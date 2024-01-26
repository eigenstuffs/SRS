extends Button

signal move_selected(resource : SocialWarfareMove)

@export var resource : SocialWarfareMove

# basically just taking all the data from our move resource
# so that we don't have to reference that, just our button

func apply_data(move_resource : SocialWarfareMove):
	resource = move_resource
	text = str(resource.move_name) + "\n" + str(resource.move_desc) + "\n" + str(resource.move_power - resource.move_variance) + " to " + str(resource.move_power + resource.move_variance) + " damage\n" + str(resource.move_intensity) + " intensity"

func _on_pressed():
	emit_signal("move_selected", resource)
