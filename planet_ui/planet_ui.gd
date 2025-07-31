extends Control

@export var collection: Collections
@export var pointer: PackedScene 
@export var camera: Camera2D
var planet_pointers: Dictionary[Control, Planet]

func _ready() -> void:
	for planet in collection.planets:
		var node = pointer.instantiate()
		planet_pointers.set(node, planet)
		add_child(node)
		

func _process(delta: float) -> void:
	for pointer: Control in get_children():
		var planet = planet_pointers.get(pointer)
		pointer.position = camera.global_position + planet.global_position;
		pointer.rotation = pointer.position.angle()
		pointer.position = Vector2(clamp(pointer.position.x, 0, size.x), clamp(pointer.position.y, 0, size.y))
