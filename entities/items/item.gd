# Base Item class
@abstract
extends Resource
class_name Item

@export var name: String = ""
@export var value: int = 0
@export var icon: Texture2D
@export var effects: Array[Resource] = []

@abstract
func use() -> void

func remove_from_inventory() -> void:
	# Get player inventory and remove item
	pass
