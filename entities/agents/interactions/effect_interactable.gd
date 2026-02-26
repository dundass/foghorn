# Interactable that applies effects
extends Interactable
class_name EffectInteractable

@export var effects: Array[Resource] = []

func interact(target: Node = null) -> void:
	for effect in effects:
		if effect is Effect:
			effect.apply(target)
