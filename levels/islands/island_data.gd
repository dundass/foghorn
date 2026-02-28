# Island definition
@tool
extends Resource
class_name IslandData

signal location_changed(new_location: Vector2i)

@export var name: String = "Island"
@export var location: Vector2i:
	set(new_location):
		if location != new_location:
			location = new_location
			# Emit signals when the property is changed.
			location_changed.emit(new_location)
			changed.emit()
@export var growth_delay: int = 5
@export var lagoon_threshold: int = 3
@export var coarse_ruleset: String = "island"
@export var fine_ruleset: String = "land"

var seeds: Dictionary = {}

func _init() -> void:
    # TODO - temp rand seeding until data is there
	if seeds.is_empty():
		var num_seeds: int = randi_range(10, 15)
		var ca_max: int = 4
		var _max_seed_dist: int = 3
		for i in range(num_seeds):
			var seed_pos: Vector2i = Vector2i(
				randi_range(-_max_seed_dist, _max_seed_dist),
				randi_range(-_max_seed_dist, _max_seed_dist)
			)
			seeds[seed_pos] = randi_range(1, ca_max)