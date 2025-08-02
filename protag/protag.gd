class_name Protag
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
@export var placing_planet: Planet
@export var invalid_place: Texture
@export var valid_place: Texture
@export var previous_planet_pos: Vector2 # used for trajectory prediction
@export var planet_inventory: Array[PackedScene]

func _physics_process(delta: float) -> void:
	if placing_planet:
		try_place_planet()
		return
	
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
	
	inventory[Harvestable.variant_to_string(plant.Type)] += 1;
	
func process_plants():
	if !Input.is_action_just_pressed("plant"):
		return;
		
	#plant(plant_type)


func plant(type: Harvestable.PlantType):
	var seed = Harvestable.variant_to_string(type) + "_seeds"

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
		
	var input: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		input += Vector2.LEFT.rotated(global_rotation)
	if Input.is_action_pressed("move_right"):
		input += Vector2.RIGHT.rotated(global_rotation)
	if Input.is_action_pressed("fall"):
		input += Vector2.DOWN.rotated(global_rotation)
	if Input.is_action_pressed("float"):
		input += Vector2.UP.rotated(global_rotation)
	
	for planet in root_node.planets:
		if planet.global_position.distance_squared_to(global_position) < pow(planet.size, 2):
			attached = planet
			characterbody.velocity = Vector2.ZERO
			return
		if planet.global_position.distance_squared_to(global_position) - pow(planet.size * planet.density_modifier + 1000, 2) < pow(planet.size, 2) :
			var distance = ((planet.global_position - global_position))
			var grav_force = (-pow(1.1, distance.length() / 1000.) + 1000) 
			if grav_force < 0:
				print("ignored")
				continue
			var force = grav_force * distance.normalized() * delta * planet.density_modifier
			characterbody.velocity += force + (input * 10);
			print("distance")
	
	var MAX_DISTANCE: float = 35_000
	if Input.is_action_pressed("fall"):
		MAX_DISTANCE -= 10_000
	if global_position.length_squared() > pow(MAX_DISTANCE, 2):
		var force = -position.normalized() \
			* max(abs(position.x) - MAX_DISTANCE, abs(position.y) - MAX_DISTANCE) \
			* delta
		characterbody.velocity += force;
		if characterbody.velocity.dot(force) > 0:
			characterbody.velocity += force;
		
	


func _on_shop_purchased(
	#type: Harvestable.PlantType, cost: int, price_type: Harvestable.PlantType
	purchase_button: PurchaseButton
) -> void:
	var type = purchase_button.buying
	var cost = purchase_button.cost
	var price_type = purchase_button.cost_type
	var cost_type = Harvestable.variant_to_string(price_type)
	if inventory[cost_type] < cost:
		return
	
	inventory[cost_type] -= cost
	
	match type:
		Harvestable.PlantType.None:
			return
		Harvestable.PlantType.SmallPlanet:
			activate_place_planet()
			return
	purchase_button.increase_cost()
	plant(type)

func activate_place_planet():
	var planet: Planet = planet_inventory[0].instantiate()
	planet.visible = false
	$"../Sun".process_mode = Node.PROCESS_MODE_DISABLED
	planet.process_mode = Node.PROCESS_MODE_DISABLED
	%MainCamera.toggle_camera("Space")
	$PlanetIndicator.visible = true
	$PlanetIndicator.scale = Vector2(planet.size, planet.size) / 40
	$"..".add_child(planet)
	$"..".planets.append(planet)
	placing_planet = planet

func try_place_planet():
	placing_planet.global_position = get_global_mouse_position()
	$PlanetIndicator.global_position = placing_planet.global_position
	if previous_planet_pos != placing_planet.global_position:
		$"../Sun/PredictionSun".reset_prediction()
		previous_planet_pos = placing_planet.global_position
	
	if Input.is_action_just_pressed("harvest"):
		$"../Sun".process_mode = Node.PROCESS_MODE_INHERIT
		$PlanetIndicator.visible = false
		$"..".planets.pop_back()
		$"../Sun/PredictionSun".reset_prediction()
		placing_planet.queue_free()
		%MainCamera.toggle_camera("Range")
		placing_planet = null
		return
	
	for planet: Planet in $"..".planets:
		if planet == placing_planet:
			continue
		if planet.global_position.distance_to(placing_planet.global_position) \
			< planet.size + placing_planet.size + 300:
			$PlanetIndicator.texture = invalid_place
			$PlanetIndicator.scale = Vector2(placing_planet.size, placing_planet.size) / 40
			
			return
	$PlanetIndicator.texture = valid_place
	$PlanetIndicator.scale = Vector2(placing_planet.size, placing_planet.size) / 1150
	
	
	if Input.is_action_just_pressed("plant"):
		placing_planet.process_mode = Node.PROCESS_MODE_INHERIT
		placing_planet.scale = Vector2.ONE * placing_planet.size * 2
		placing_planet.visible = true
		$"../Sun".process_mode = Node.PROCESS_MODE_INHERIT
		$"../Sun/PredictionSun".reset_prediction()
		$PlanetIndicator.visible = false
		%MainCamera.toggle_camera("Range")
		
		for plant in placing_planet.preset_plants:
			$"..".harvestable_plants.append(plant)
		
		placing_planet = null
		
