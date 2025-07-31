class_name Harvestable
extends Attachable

enum PlantType {
	None = 0,
	Berry = 1,
	Flower = 2,
}

@export var Type: PlantType
@export var progress_to_harvest: float
@export var progression_rate: float = 0.2
@export var ready_to_harvest: bool
@export_group("Staged growth properties")
@export var stage_textures: Array[Texture] 
var harvest_texture: Texture

var instantiated = false
func _ready() -> void:
	harvest_texture = self.texture
	if !instantiated:
		%Collections.harvestable_plants.append(self)

func _process(delta: float) -> void:
	if ready_to_harvest:
		self.texture = harvest_texture
		return
	var stage = progress_to_harvest * stage_textures.count()

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
