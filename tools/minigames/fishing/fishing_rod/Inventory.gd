extends Control

@onready var RODS : FishingRodTypes = preload("res://tools/minigames/fishing/fishing_rod/types_of_rod.tres")
@onready var rods_container = $RodsContainer
@onready var inventory_item = $InventoryItem


func _ready():
	inventory_item.hide()


func _on_texture_button_pressed():
	RODS.set_rod_stats(0,inventory_item)
	inventory_item.show()


func _on_texture_button_3_pressed():
	RODS.set_rod_stats(1,inventory_item)
	inventory_item.show()


func _on_texture_button_4_pressed():
	pass 


func _on_texture_button_5_pressed():
	pass



func _on_button_pressed():
	print("hi")


#equips the fishing rod
func _on_equip_button_pressed():
	pass 
