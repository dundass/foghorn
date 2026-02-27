# Effect that modifies health
extends Effect
class_name ModifyHealth

@export var amount: float = 0.0  # Positive to heal, negative to damage

func apply(target: Node) -> void:
	if target:
		var stats: CharacterStats = target.get_meta("stats") if target.has_meta("stats") else null
		if stats and stats is CharacterStats:
			if amount < 0:
				stats.take_damage(-amount)
			else:
				stats.restore_health(amount)
			pass
