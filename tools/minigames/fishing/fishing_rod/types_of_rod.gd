extends Resource

class_name FishingRodTypes

@export var rod_one : Dictionary = {"name": "Default Fishing Rod", "sell_price": 250, "buy_price": 300, "description": "standard fishing rod. it catches fish.", "held": 1}
@export var rod_two : Dictionary = {"name": "Cooler Fishing Rod", "sell_price": 300, "buy_price": 350, "description": "a fishing rod, but cooler.", "held": 1}
@export var rod_list : Array[Dictionary] = [rod_one,rod_two]





func set_rod_stats(rod_type : int, rod : InventoryItem):
	rod.get_node("Description").text = rod_list[rod_type].get("description")
	rod.get_node("Name").text = rod_list[rod_type].get("name")
	rod.get_node("SellPrice").text = str(rod_list[rod_type].get("sell_price"))
	rod.get_node("BuyPrice").text = str(rod_list[rod_type].get("buy_price"))
	rod.get_node("MaxHeld").text = str(rod_list[rod_type].get("held"))
