extends Node

class_name SharkTankPitchHandler

var current_pitch : SharkTankPitches = null

signal pitch_complete

func init_pitch(pitch : SharkTankPitches):
	current_pitch = pitch
	await pitch_complete
