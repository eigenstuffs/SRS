class_name SettingScene extends Control

signal exit_settings

@onready var vol_label = $GridContainer/MasterVolumeControl/Description
@onready var text_label = $GridContainer/TextSpeedControl/Description
@onready var effects_label = $GridContainer/HeavyVisualEffectsButton/Label

@onready var master_volume_slider := $GridContainer/MasterVolumeControl/Slider
@onready var text_speed_slider := $GridContainer/TextSpeedControl/Slider
@onready var effects_button := $GridContainer/HeavyVisualEffectsButton/Button

func init():
	master_volume_slider.value = Global.data_dict["volume"]
	text_speed_slider.value = 1.0 / Global.data_dict["text_speed"] # text_speed is seconds per character
	effects_button.button_pressed = Global.meta_data_dict["effect_on"]
	
	vol_label.text = 'Current Volume: %.1fdb' % master_volume_slider.value
	text_label.text = 'Characters per Second: %d' % text_speed_slider.value
	effects_label.text = 'Enabled' if effects_button.button_pressed else 'Disabled'

func _on_master_volume_value_changed(value):
	Global.data_dict["volume"] = value
	vol_label.text = 'Current Volume: %ddb' % value

func _on_text_speed_value_changed(value):
	Global.data_dict["text_speed"] = 1.0 / value # text_speed is seconds per character
	text_label.text = 'Characters per Second: %d' % value

func _on_texture_button_2_pressed():
	Global.save_meta_data()
	exit_settings.emit()

func _on_effects_button_toggled(toggled_on):
	Global.meta_data_dict["effect_on"] = toggled_on
	effects_label.text = 'Enabled' if toggled_on else 'Disabled'


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN else DisplayServer.WINDOW_MODE_WINDOWED)
