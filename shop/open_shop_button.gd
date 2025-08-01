extends Button

func _process(delta: float) -> void:
	position = Vector2(10, 10 + (%ShopInterface.progress * -200))
