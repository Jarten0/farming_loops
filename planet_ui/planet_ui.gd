extends Node2D

@export var collection: Collections
@export var pointer: PackedScene 
@export var camera: Camera2D
var planet_pointers: Dictionary[Node2D, Planet]

func _ready() -> void:
	for planet in collection.planets:
		var node = pointer.instantiate()
		planet_pointers.set(node, planet)
		add_child(node)
		

func _process(delta: float) -> void:
	for pointer: Sprite2D in get_children():
		var planet = planet_pointers.get(pointer)
		pointer.global_position = planet.global_position;
		pointer.rotation = pointer.global_position.angle()
		pointer.global_position = pointer.global_position.normalized() * clamp(pointer.global_position.length(), -100, 100)
