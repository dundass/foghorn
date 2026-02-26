# Effect that modifies health
extends Effect
class_name ModifyHealth


func apply(target: Node) -> void:
	if target:
		var stats: CharacterStats = target.get_meta("stats") if target.has_meta("stats") else null
		if stats and stats is CharacterStats:
			# TODO: Implement health modification
			# stats.health += amount
			pass
