# Stat with modifiers
class_name Stat


@export var base_value: float = 0.0

var _modifiers: Array[float] = []


func get_value() -> float:
	var final_value: float = base_value
	for modifier in _modifiers:
		final_value += modifier
	return final_value


func add_modifier(mod: float) -> void:
	if mod != 0:
		_modifiers.append(mod)


func remove_modifier(mod: float) -> void:
	if mod != 0:
		_modifiers.erase(mod)
