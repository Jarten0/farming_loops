extends Harvestable

@export var flower_bundle: Array[Sprite2D]

func _process(delta: float) -> void:
	for flower in flower_bundle:
		flower.visible = ready_to_harvest
	
	super._process(delta)
