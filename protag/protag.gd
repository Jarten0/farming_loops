extends Attachable

@export var inventory: Dictionary[String, int]
@export var plant_type: Harvestable.PlantType
@export var root_node: Collections

func _physics_process(delta: float) -> void:
	var input: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		input += Vector2.LEFT.rotated(global_rotation)
	if Input.is_action_pressed("move_right"):
		input += Vector2.RIGHT.rotated(global_rotation)
	global_position += input * delta * 1000.;
	
	%MainCamera.global_rotation = global_rotation;
	process_harvests()
	process_plants()
	super._physics_process(delta)
	pass
	
func process_harvests() -> void:
	if !Input.is_action_just_pressed("harvest"):
		return
	
	for plant: Harvestable in root_node.harvestable_plants:
		if !plant.ready_to_harvest:
			continue
	
		if global_position.distance_squared_to(plant.global_position) < pow(200, 2):
			harvest(plant)
			break

func harvest(plant: Harvestable):
	plant.harvest()
	
	match plant.Type:
		Harvestable.PlantType.None:
			pass
		Harvestable.PlantType.Berry:
			inventory["berries"] += 1;
		Harvestable.PlantType.Flower:
			inventory["flowers"] += 1;
		
	
func process_plants():
	if !Input.is_action_just_pressed("plant"):
		return;
		
	plant(plant_type)


func plant(type: Harvestable.PlantType):
	match plant_type:
		Harvestable.PlantType.None:
			return;
		Harvestable.PlantType.Berry:
			if inventory["berries"] < 3:
				return
			inventory["berries"] -= 3
		Harvestable.PlantType.Strawberry:
			if inventory["strawberries"] < 5:
				return
			inventory["strawberries"] -= 5
		Harvestable.PlantType.Flower:
			if inventory["flowers"] < 5:
				return
			inventory["flowers"] -= 5
		Harvestable.PlantType.Tomato:
			if inventory["tomatos"] < 5:
				return
			inventory["tomatos"] -= 5
		Harvestable.PlantType.Carrot:
			if inventory["carrots"] < 5:
				return
			inventory["carrots"] -= 5
		Harvestable.PlantType.Wheat:
			if inventory["wheat"] < 5:
				return
			inventory["wheat"] -= 5

	var scene: PackedScene = root_node.plantable_plants[type]
	
	var plant: Harvestable = scene.instantiate()
	plant.global_position = global_position
	plant.attached = attached
	root_node.harvestable_plants.append(plant)
	
	root_node.add_child(plant, true)
	
	pass
