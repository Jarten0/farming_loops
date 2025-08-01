extends Button

func _ready() -> void:
	visible = false

func _physics_process(delta: float) -> void:
	if visible:
		return
	for child in get_children():
		if child is BuyWith:
			if child.unlocked:
				visible = true
				return
