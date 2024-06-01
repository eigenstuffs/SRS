extends Control


func _on_down_text_pressed():
	Global.data_dict["text_speed"] -= 0.01
	#Global.save_data()

func _on_up_text_pressed():
	Global.data_dict["text_speed"] += 0.01
	#Global.save_data()
