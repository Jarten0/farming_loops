extends Attachable

@export var berries: int = 0
@export var plant_type: Harvestable.PlantType


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
	
	for plant: Harvestable in %Collections.harvestable_plants:
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
			berries += 1;
		
	
func process_plants():
	if !Input.is_action_just_pressed("plant"):
		return;
		
	plant(plant_type)


func plant(type: Harvestable.PlantType):
	match plant_type:
		Harvestable.PlantType.None:
			return;
		Harvestable.PlantType.Berry:
			if berries >= 3:
				berries -= 3
			else:
				return

	var scene: PackedScene = %Collections.plantable_plants[type]
	
	var plant: Harvestable = scene.instantiate()
	plant.global_position = global_position
	plant.attached = attached
	plant.instantiated = true
	%Collections.harvestable_plants.append(plant)
	
	$"/root/Main Level".add_child(plant, true)
	
	pass
