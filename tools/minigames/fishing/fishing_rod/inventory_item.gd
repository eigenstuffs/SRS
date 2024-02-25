extends Control

class_name InventoryItem

@onready var ROD_TYPE : FishingRodTypes = load("res://tools/minigames/fishing/fishing_rod/types_of_rod.tres")
@onready var rod_name = $Background/VBoxContainer/HBoxContainer2/Name
@onready var rod_pic = $Background/VBoxContainer/HBoxContainer2/Photo
@onready var description = $Background/VBoxContainer/Description
@onready var sell_price = $Background/VBoxContainer/HBoxContainer/SellPrice
@onready var buy_price = $Background/VBoxContainer/HBoxContainer/BuyPrice
@onready var max_held = $Background/VBoxContainer/HBoxContainer/MaxHeld

func show_description(rod_type : int):
	rod_name.text = ROD_TYPE.rod_list[rod_type].get("name")
	description.text = ROD_TYPE.rod_list[rod_type].get("description")
	sell_price.text = str(ROD_TYPE.rod_list[rod_type].get("sell_price"))
	buy_price.text = str(ROD_TYPE.rod_list[rod_type].get("buy_price"))
	max_held.text = str(ROD_TYPE.rod_list[rod_type].get("held"))
