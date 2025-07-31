extends Control

@export var buttons: Array[Control]
@export var progress: float = 0
@export var is_open = false

func open():
	is_open = true
	
func close():
	is_open = false

func _process(delta: float) -> void:
	if is_open && progress < 1:
		progress = clamp(progress + delta, 0, 1)
	elif !is_open && progress > 0:
		progress = clamp(progress - delta, 0, 1)
	
	var positions: Array[Vector2] = []
	for button in buttons:
		positions.append(button.position)
		
	var i = 0
	for position in positions:
		var target_position = (i * 35) + 510
		buttons[i].position = Vector2(10, (target_position * progress) - 500)
		i += 1
