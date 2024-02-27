extends Resource

class_name FishingRodTypes

@export var rod_one : Dictionary = {"name": "Default Fishing Rod", "description": "standard fishing rod. it catches fish."}
#"sell_price": 250, "buy_price": 300, "held": 1
@export var rod_two : Dictionary = {"name": "Cooler Fishing Rod", "description": "a fishing rod, but cooler."}
#"sell_price": 300, "buy_price": 350, "held": 1
@export var rod_three: Dictionary = {"name": "Superior Fishing Rod", "description": "they say that this is the rod of the masters."}
@export var rod_four: Dictionary = {"name": "BEST Fishing Rod", "description": "a rod with faded lettering on the handle. 'Cult de Poisson'...?"}
@export var rod_list : Array[Dictionary] = [rod_one,rod_two, rod_three, rod_four]





func set_rod_stats(rod_type : int, rod : InventoryItem):
	rod.get_node("Description").text = rod_list[rod_type].get("description")
	rod.get_node("Name").text = rod_list[rod_type].get("name")
	#rod.get_node("SellPrice").text = str(rod_list[rod_type].get("sell_price"))
	#rod.get_node("BuyPrice").text = str(rod_list[rod_type].get("buy_price"))
	#rod.get_node("MaxHeld").text = str(rod_list[rod_type].get("held"))
