class_name BuyWith
extends Button

signal bought(buy_with: BuyWith)

@export var unlocked = false
@export var buying: Harvestable.PlantType 
@export var cost: int
@export var cost_type: Harvestable.PlantType

func _physics_process(delta: float) -> void:
	var count = %"ShopInterface".get_parent().protag.inventory[
		Harvestable.variant_to_string(cost_type)
	]
	
	if !unlocked && count > 0:
		unlocked = true
	
	text = String.num(count, 0) + "/" + String.num(cost, 0)

func _on_pressed() -> void:
	bought.emit(self)
