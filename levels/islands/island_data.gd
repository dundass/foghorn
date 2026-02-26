# Island definition
extends Resource
class_name IslandData

@export var name: String = "Island"
@export var location: Vector2i
@export var growth_delay: int = 5
@export var lagoon_threshold: int = 3
@export var ruleset: String = "island"

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