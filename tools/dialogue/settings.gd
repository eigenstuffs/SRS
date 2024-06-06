extends Control

func _ready():
	$MasterVolume.value = Global.data_dict["volume"]
	$TextSpeed.value = Global.data_dict["text_speed"]

func _on_master_volume_value_changed(value):
	Global.data_dict["volume"] = $MasterVolume.value

func _on_text_speed_value_changed(value):
	Global.data_dict["text_speed"] = $TextSpeed.value
