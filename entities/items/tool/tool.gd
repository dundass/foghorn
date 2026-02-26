# Tool item that applies effects
extends Item
class_name Tool


func use() -> void:
	# Apply effects from inherited list
	for effect in effects:
		# effect.apply(get_parent())
		pass
