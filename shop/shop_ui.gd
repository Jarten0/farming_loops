extends Control

signal purchased(type: Harvestable.PlantType, cost: int, price_type: Harvestable.PlantType)

@export var protag: Protag
@export var buttons: Array[Node2D]

func _on_buy_with_pressed(buy_with: BuyWith) -> void:
	purchased.emit(
		buy_with.buying,
		buy_with.cost,
		buy_with.cost_type
	)
