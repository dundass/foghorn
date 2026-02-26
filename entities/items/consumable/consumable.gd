# Consumable item that can be used and removed
extends Item
class_name Consumable


func use() -> void:
	# Apply effects
	for effect in effects:
		# effect.apply(get_parent())
		pass
	
	remove_from_inventory()
