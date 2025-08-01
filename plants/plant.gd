class_name Harvestable
extends Attachable

enum PlantType {
	None = 0,
	Berry = 1,
	Flower = 2,
	Strawberry = 3,
	Tomato = 4,
	Carrot = 5,
	Wheat = 6,
	SmallPlanet = 7,
}

static func variant_to_string(type: PlantType) -> String:
	match type:
		Harvestable.PlantType.None:
			return "";
		Harvestable.PlantType.Berry:
			return "blueberry"
		Harvestable.PlantType.Strawberry:
			return "strawberry"
		Harvestable.PlantType.Flower:
			return "flower"
		Harvestable.PlantType.Tomato:
			return "tomato"
		Harvestable.PlantType.Carrot:
			return "carrot"
		Harvestable.PlantType.Wheat:
			return "wheat"
	return ""

@export var Type: PlantType
@export var progress_to_harvest: float
@export var progression_rate: float = 0.2
@export var ready_to_harvest: bool
@export_group("Staged growth properties")
@export var stage_textures: Array[Texture] 
var harvest_texture: Texture

func _ready():
	if !harvest_texture:
		harvest_texture = self.texture

func _process(delta: float) -> void:
	if ready_to_harvest:
		self.texture = harvest_texture
		return
	var stage = floor(progress_to_harvest * stage_textures.size())
	self.texture = stage_textures[stage]
	

func _physics_process(delta: float) -> void:
	if ready_to_harvest:
		return;
	progress_to_harvest += progression_rate * delta
	if progress_to_harvest >= 1:
		progress_to_harvest = 1;
		ready_to_harvest = true;
	super._physics_process(delta)
		
func harvest():
	ready_to_harvest = false;
	progress_to_harvest = 0.
