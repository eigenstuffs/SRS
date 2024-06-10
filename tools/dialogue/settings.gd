class_name SettingScene extends Control

signal exit_settings

@onready var vol_label = $ScrollContainer/Columns/EntryControls/MasterVolumeSlider/Description
@onready var text_label = $ScrollContainer/Columns/EntryControls/TextSpeedSlider/Description
@onready var effects_label = $ScrollContainer/Columns/EntryControls/HeavyVisualEffectsButton/Button/Label
@onready var fullscreen_label = $ScrollContainer/Columns/EntryControls/FullscreenButton/Button/Label

@onready var master_volume_slider := $ScrollContainer/Columns/EntryControls/MasterVolumeSlider
@onready var master_volume_progress_bar := $ScrollContainer/Columns/EntryControls/MasterVolumeSlider/ProgressBar
@onready var text_speed_slider := $ScrollContainer/Columns/EntryControls/TextSpeedSlider
@onready var text_speed_progress_bar := $ScrollContainer/Columns/EntryControls/TextSpeedSlider/ProgressBar
@onready var effects_button := $ScrollContainer/Columns/EntryControls/HeavyVisualEffectsButton/Button

func init():
	master_volume_slider.value = Global.data_dict["volume"]
	text_speed_slider.value = 1.0 / Global.data_dict["text_speed"] # text_speed is seconds per character
	effects_button.button_pressed = Global.meta_data_dict["effect_on"]
	
	vol_label.text = 'Current Volume: %ddb' % master_volume_slider.value
	text_label.text = 'Characters per Second: %d' % text_speed_slider.value
	effects_label.text = _get_toggle_text(effects_button.button_pressed)

func _on_master_volume_value_changed(value):
	Global.data_dict["volume"] = value
	vol_label.text = 'Current Volume: %ddb' % value
	_set_slider_progress(master_volume_progress_bar, master_volume_slider)

func _on_text_speed_value_changed(value):
	Global.data_dict["text_speed"] = 1.0 / value # text_speed is seconds per character
	text_label.text = 'Characters per Second: %d' % value
	_set_slider_progress(text_speed_progress_bar, text_speed_slider)

func _on_save_button_pressed() -> void:
	Global.save_meta_data()
	exit_settings.emit()

func _on_effects_button_toggled(toggled_on):
	Global.meta_data_dict["effect_on"] = toggled_on
	effects_label.text = _get_toggle_text(toggled_on)


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN else DisplayServer.WINDOW_MODE_WINDOWED)
	fullscreen_label.text = _get_toggle_text(toggled_on)

func _get_toggle_text(is_toggled : bool) -> String:
	return 'Enabled' if is_toggled else 'Disabled'

func _set_slider_progress(progress_bar : Range, slider : HScrollBar) -> void:
	# Gotta lerp between 3 and 97 (assuming progress bar is between 0 and 100) so that darkened area stays
	# in the middle of the slider knob.
	progress_bar.set_value_no_signal(lerpf(0+3, 100-3, (slider.value - slider.min_value) / (slider.max_value - slider.min_value)))
