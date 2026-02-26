# Island test component for editor preview
extends Node
class_name IslandTestComponent


@export var island_location: Vector2 = Vector2(150, 100)
@export var grid_size: int = 384
@export var growth_delay: int = 5
@export var max_iterations: int = 11

# Seed parameters
@export var num_seeds: int = 12
@export var min_seed_state: int = 1
@export var max_seed_state: int = 4
@export var seed_spread_range: int = 10
@export var random_seed: int = 0
@export var auto_randomize_seed: bool = true

# Ruleset
@export var ruleset_name: String = "island"

# References
@export var terra_generator: Node
@export var world_renderer: Node

# Cache for preview
var preview_ca: CA2D
var generated_seeds: Dictionary = {}
var last_generation_iteration: int = -1

# For editor preview
var preview_texture: Image
var tile_colors: Array[Color] = []


func _validate_properties() -> void:
	# Clamp values
	growth_delay = max(0, growth_delay)
	max_iterations = max(1, max_iterations)
	num_seeds = max(1, num_seeds)
	min_seed_state = max(1, min_seed_state)
	max_seed_state = max(min_seed_state, max_seed_state)
	seed_spread_range = max(1, seed_spread_range)
	grid_size = max(64, grid_size)
