extends Control

signal purchased(type: Harvestable.PlantType)
@export var protag: Protag
@export var prices: Dictionary[String, int]
@export var price_type: Dictionary[String, Harvestable.PlantType]

func _on_blueberry_pressed() -> void:
	purchased.emit(Harvestable.PlantType.Berry)


func _on_strawberry_pressed() -> void:
	purchased.emit(Harvestable.PlantType.Strawberry)


func _on_tomatoes_pressed() -> void:
	purchased.emit(Harvestable.PlantType.Tomato)


func _on_carrots_pressed() -> void:
	purchased.emit(Harvestable.PlantType.Carrot)


func _on_wheat_pressed() -> void:
	purchased.emit(Harvestable.PlantType.Wheat)
