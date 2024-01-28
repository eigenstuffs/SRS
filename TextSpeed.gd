extends Control


func _on_down_text_pressed():
	Global.text_speed -= 0.01


func _on_up_text_pressed():
	Global.text_speed += 0.01
