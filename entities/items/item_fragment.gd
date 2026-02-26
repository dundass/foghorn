# Item fragment that represents a broken piece of an item
extends Item
class_name ItemFragment

@export var complete_item: Item

func get_display_name() -> String:
	if complete_item != null:
		return "Bit of old " + complete_item.display_name
	return "Unknown Fragment"


func use() -> void:
	# TODO: Find matching fragment in inventory and combine
	# If found, remove both fragments and add the complete_item
	remove_from_inventory()
