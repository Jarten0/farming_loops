extends Control

signal purchased(button: PurchaseButton)

@export var protag: Protag
@export var buttons: Array[Node2D]

func _on_buy_with_pressed(buy_with: PurchaseButton) -> void:
	purchased.emit(
		buy_with
	)
