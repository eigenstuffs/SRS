extends Control

signal exit_settings

func init():
	$MasterVolume.value = Global.data_dict["volume"]
	$TextSpeed.value = Global.data_dict["text_speed"]

func _on_master_volume_value_changed(value):
	Global.data_dict["volume"] = $MasterVolume.value

func _on_text_speed_value_changed(value):
	Global.data_dict["text_speed"] = $TextSpeed.value

func _on_texture_button_toggled(toggled_on):
	Global.data_dict["effect_on"] = toggled_on
	match toggled_on:
		true:
			$Label6.text = "Enabled"
		false:
			$Label6.text = "Disabled"
		
func _on_texture_button_2_pressed():
	exit_settings.emit()
