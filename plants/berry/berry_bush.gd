extends Harvestable

@export var StageOne: Texture
@export var StageTwo: Texture

#func _ready() -> void:
	#var sprite = Sprite2D.new()
	#sprite.texture = StageOne
	#add_child(sprite)

func _process(delta: float) -> void:
	#var sprite: Sprite2D = get_child(0)
	if !ready_to_harvest:
		self.texture = StageOne;
	else:
		self.texture = StageTwo;
