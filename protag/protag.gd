extends Attachable

@export var inventory: Dictionary[String, int]
@export var plant_type: Harvestable.PlantType
@export var root_node: Collections
# because of inheritance heirarchies and a lack of trait functionality,
# the script uses a reference to the methods through here. 
# this should be assigned to the script's own node.
@export var characterbody: CharacterBody2D
@export var jump_strength: float = 100
@export var move_speed: float = 1000

func _physics_process(delta: float) -> void:
	process_gravity(delta)

	if !attached:
		characterbody.move_and_slide()
		return

	var input: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		input += Vector2.LEFT.rotated(global_rotation)
	if Input.is_action_pressed("move_right"):
		input += Vector2.RIGHT.rotated(global_rotation)
		
	if Input.is_action_just_pressed("jump") && attached:
		attached = null
		characterbody.velocity = Vector2.UP.rotated(global_rotation) * jump_strength
		characterbody.velocity += input * move_speed
		position += Vector2.UP.rotated(global_rotation) * 100

	global_position += input * delta * move_speed;
	characterbody.move_and_slide()
	
	%MainCamera.target_rotation = global_rotation;
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
			if inventory["flowers"] < 2:
				return
			inventory["flowers"] -= 2
		Harvestable.PlantType.Tomato:
			if inventory["tomatos"] < 5:
				return
			inventory["tomatos"] -= 5
		Harvestable.PlantType.Carrot:
			if inventory["carrots"] < 2:
				return
			inventory["carrots"] -= 2
		Harvestable.PlantType.Wheat:
			if inventory["wheat"] < 2:
				return
			inventory["wheat"] -= 2

	var scene: PackedScene = root_node.plantable_plants[type]
	
	var plant: Harvestable = scene.instantiate()
	plant.global_position = global_position
	plant.attached = attached
	root_node.harvestable_plants.append(plant)
	
	root_node.add_child(plant, true)
	
	pass

func process_gravity(delta: float):
	if attached:
		return
	
	for planet in root_node.planets:
		if planet.global_position.distance_squared_to(global_position) < pow(planet.size, 2):
			attached = planet
			characterbody.velocity = Vector2.ZERO
			return
		if planet.global_position.distance_squared_to(global_position) - pow(planet.size * planet.density_modifier + 1000, 2) < pow(planet.size, 2) :
			var distance = (planet.global_position - global_position)
			var grav_force = (-pow(1.1, distance.length() / 1000.) + 1000) 
			if grav_force < 0:
				print("ignored")
				continue
			characterbody.velocity += grav_force * distance.normalized() * delta * planet.density_modifier;
			print("distance")
		
		
	var input: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		input += Vector2.LEFT.rotated(global_rotation)
	if Input.is_action_pressed("move_right"):
		input += Vector2.RIGHT.rotated(global_rotation)
