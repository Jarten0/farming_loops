class_name Harvestable
extends Attachable

enum PlantType {
	None,
	Berry,
	
}

@export var Type: PlantType
@export var progress_to_harvest: float
@export var progression_rate: float = 0.2
@export var ready_to_harvest: bool

var instantiated = false
func _ready() -> void:
	if !instantiated:
		%Collections.harvestable_plants.append(self)

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
