extends Control


func _on_down_vol_pressed():
	Global.volume -= 1


func _on_up_vol_pressed():
	Global.volume += 1
