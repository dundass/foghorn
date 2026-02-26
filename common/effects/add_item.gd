# Effect that adds items to inventory
extends Effect
class_name AddItem


@export var items: Array[Item] = []


func apply(target: Node) -> void:
	if target:
		var inventory: Inventory = target.get_node_or_null("Inventory")
		if inventory and inventory is Inventory:
			for item in items:
				inventory.add(item)
