extends Control


func _on_down_vol_pressed():
	Global.data_dict["volume"] -= 1
	#Global.save_data()

func _on_up_vol_pressed():
	Global.data_dict["volume"] += 1
	#Global.save_data()
