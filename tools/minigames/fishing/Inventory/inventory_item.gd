extends Control

class_name InventoryItem

@onready var ROD_TYPE : FishingRodTypes = load("res://tools/minigames/fishing/Inventory/types_of_rod.tres")
@onready var rod_name = $Background/VBoxContainer/HBoxContainer2/Name
@onready var rod_pic = $Background/VBoxContainer/HBoxContainer2/Photo
@onready var description = $Background/VBoxContainer/Description
@onready var reel_strength = $Background/VBoxContainer/HBoxContainer/ReelStr
@onready var reel_size = $Background/VBoxContainer/HBoxContainer/ReelSize

func show_description(rod_type : int):
	rod_name.text = ROD_TYPE.rod_list[rod_type].get("name")
	description.text = ROD_TYPE.rod_list[rod_type].get("description")
	reel_strength.text = "reel strength: " + str(ROD_TYPE.rod_list[rod_type].get("reel_strength"))
	reel_size.text = "reel size: " + str(ROD_TYPE.rod_list[rod_type].get("reel_size"))
