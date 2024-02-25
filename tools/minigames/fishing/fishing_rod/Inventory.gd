#class_name RodSelection extends Minigame
extends Control

@onready var ROD_TYPE : FishingRodTypes = preload("res://tools/minigames/fishing/fishing_rod/types_of_rod.tres")
@onready var rods_container = $CanvasLayer/ScrollContainer/RodsContainer
@onready var inventory_item = $CanvasLayer/VBoxContainer/InventoryItem
#is it better to have select button and description in a container? or just separate them
@onready var rod_chosen : int
@export var fishing_scene : PackedScene

func _ready():
	inventory_item.hide()


func _on_texture_button_pressed():
	inventory_item.show_description(0)
	inventory_item.show()
	rod_chosen = 0


func _on_texture_button_3_pressed():
	inventory_item.show_description(1)
	inventory_item.show()
	rod_chosen = 1


func _on_texture_button_4_pressed():
	pass 


func _on_texture_button_5_pressed():
	pass


#equips the fishing rod
func _on_equip_button_pressed():
	print("Rod chosen: " + ROD_TYPE.rod_list[rod_chosen].get("name"))
	Util.create_minigame($MinigameLayer, "Fishing")
	$CanvasLayer.visible = false

#something to call CanvasLayer back again
