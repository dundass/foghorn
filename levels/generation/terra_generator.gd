# Terra generator - advanced world generation with cellular automata
extends Node
class_name TerraGenerator

@export var _islands: Array[IslandData]
@export var chunk_cell_iterations: int = 11
@export var upscale_cell_iterations: int = 2
@export var lagoon_removal_chance: float = 0.95
@export var generate_settlements: bool = false
@export var generate_environmental_props: bool = false

@export var world_renderer: WorldRenderer
@export var player: CharacterBody2D

@export var denizen_parent: Node
@export var denizen_prefab: Node

enum BlockType {
	GROUND = 1,
	FOREST = 2,
	MOUNTAIN = 3
}

var land_ca: CA2D
var house_ca: CA2D
var chunk_ca: CA2D
var forest_ca: CA2D

var _rulesets: Dictionary = {
	"island": [0, 0, 3, 0, 3, 0, 2, 0, 3, 3, 3, 2, 3, 0, 3, 0, 0, 1, 2, 0, 0, 2, 2, 0, 1, 3, 0, 0, 0, 0, 3, 0],
	"island2": [0, 1, 0, 1, 0, 0, 1, 3, 3, 0, 1, 0, 2, 3, 0, 0, 3, 1, 0, 2, 3, 3, 0, 3, 0, 2, 0, 0, 3, 3, 0, 0],
	"island3": [0, 0, 3, 0, 3, 0, 2, 0, 3, 3, 3, 2, 3, 0, 3, 0, 0, 1, 2, 0, 0, 2, 2, 0, 1, 3, 0, 0, 0, 0, 3, 0],
	"ground": [0, 0, 0, 1, 2, 0, 0, 3, 0, 1, 0, 0, 1, 0, 0, 0, 0, 2, 0, 0, 1, 1, 3, 0, 0, 0, 0, 0, 3, 0, 3, 1],
	"forest": [0, 0, 0, 1, 0, 0, 1, 3, 3, 0, 1, 0, 2, 3, 0, 0, 3, 1, 0, 2, 3, 3, 0, 3, 3, 2, 0, 0, 3, 3, 0, 0],
	"mountain": [0, 0, 3, 0, 3, 0, 2, 0, 3, 3, 3, 2, 3, 0, 3, 0, 0, 1, 2, 0, 0, 2, 2, 0, 1, 3, 0, 0, 0, 0, 3, 0],
	"land": [0, 1, 1, 1, 2, 9, 1, 4, 1, 2, 2, 1, 2, 1, 2, 2, 2, 2, 1, 2, 2, 3, 2, 3, 3, 4, 3, 3, 4, 4, 4, 1, 4, 5, 4, 5, 4, 4, 5, 2, 5, 5, 4, 0, 5, 4, 4, 4, 6, 6, 6, 6, 7, 6, 6, 7, 7, 8, 4, 8, 7, 9, 7, 8, 8, 7, 8, 8, 7, 8, 8, 4, 9, 9, 9, 7, 8, 7, 9, 7],
	"land2": [0, 0, 0, 0, 0, 0, 1, 0, 1, 2, 2, 0, 2, 1, 2, 2, 2, 2, 0, 0, 0, 0, 0, 3, 3, 0, 3, 0, 4, 0, 0, 0, 4, 5, 4, 0, 4, 4, 5, 0, 5, 5, 0, 0, 5, 0, 0, 0, 6, 6, 6, 6, 7, 6, 6, 7, 7, 0, 0, 0, 0, 0, 7, 0, 8, 0, 8, 0, 0, 8, 8, 0, 9, 9, 9, 0, 0, 0, 9, 0],
	"land3": [0, 0, 0, 0, 0, 0, 0, 5, 1, 8, 0, 0, 8, 5, 3, 0, 2, 0, 0, 3, 1, 3, 0, 0, 3, 0, 0, 0, 3, 0, 4, 6, 4, 0, 0, 3, 7, 0, 0, 0, 5, 1, 9, 0, 0, 6, 0, 0, 6, 0, 4, 4, 4, 0, 1, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 9, 0, 7, 0, 0, 9, 0, 0],
	"land4": [0, 3, 0, 0, 0, 0, 7, 1, 1, 3, 0, 3, 0, 2, 0, 1, 2, 2, 0, 3, 0, 0, 0, 4, 3, 3, 9, 0, 0, 0, 5, 4, 4, 4, 0, 0, 0, 0, 0, 6, 5, 4, 0, 0, 6, 0, 0, 6, 6, 6, 2, 6, 0, 0, 0, 5, 7, 6, 0, 0, 0, 2, 0, 7, 8, 7, 0, 3, 2, 2, 6, 8, 9, 9, 0, 0, 2, 1, 5, 0],
	"house": [0, 0, 1, 0, 0, 0, 0, 0, 0, 2, 0, 2, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
}

var _block_size: int = 10

func _ready() -> void:
	# Stores all terra tile states
	land_ca = CA2D.new(10, 384 * _block_size)
	land_ca.set_ruleset(_rulesets["land"])
	
	# Set all rules for uniformly live neighbourhoods to stay at that total
	for i in range(land_ca.num_states):
		land_ca._rule_set[i * 8] = i
	
	house_ca = CA2D.new(3, 384 * _block_size)
	
	# Stores all world/island chunk states
	chunk_ca = CA2D.new(4, 384)
	chunk_ca.set_ruleset(_rulesets["island"])
	
	forest_ca = CA2D.new(3, 384 * _block_size)
	forest_ca.set_lambda_ruleset(0.3)
	
	_generate_world()
	
	if generate_settlements:
		_generate_settlements()
	
	if generate_environmental_props:
		_generate_environmental_props()
	
	if world_renderer:
		world_renderer.render_world(land_ca)
	
	if player:
		player.global_position = Vector2(_islands[0].location.x * _block_size, _islands[0].location.y * _block_size)


func _generate_world() -> void:
	print("starting island generation ...")
	
	chunk_ca.clear()
	
	# Smaller isles only get seeded after X iterations -> growth_delay
	for i in range(chunk_cell_iterations):
		for n in range(_islands.size()):
			if i == _islands[n].growth_delay:
				for island_seed: Dictionary in _islands[n].seeds:
					var x: int = int(_islands[n].location.x) + island_seed.x
					var y: int = int(_islands[n].location.y) + island_seed.y
					chunk_ca.set_cell(x, y, _islands[n].seeds[island_seed])
		chunk_ca.update()
	
	print("finished island generation !")
	print("starting upscale to main CA ...")
	
	# Interpolate the larger world chunks
	# Set cells of land CA to chunkCA and scale
	
	for i in range(land_ca.get_xsize()):
		for j in range(land_ca.get_ysize()):
			var chunk_x: int = i / _block_size
			var chunk_y: int = j / _block_size
			
			# If the tile is water
			if chunk_ca.get_cell(chunk_x, chunk_y) == 0:
				# Remove some lagoons
				if chunk_ca.get_live_neighbours(chunk_x, chunk_y) == 8 and randf() < lagoon_removal_chance:
					chunk_ca.set_cell(chunk_x, chunk_y, 1)
				else:
					continue
				
				# Add some noise to the ocean tiles
				if randf() > 0.05:
					land_ca.set_cell(i, j, randi_range(1, land_ca.num_states))
			
			# Set the land tile CA cells
			if randf() < 0.7:
				land_ca.set_cell(i, j, (chunk_ca.get_cell(chunk_x, chunk_y) * 3) + randi_range(0, 3))
	
	print("finished upscale to main CA !")
	print("starting iteration of main CA ...")
	
	land_ca.update_iterations(upscale_cell_iterations)
	
	print("finished iteration of main CA !")


func _generate_settlements() -> void:
	print("starting settlement generation ...")
	
	for i in range(land_ca.get_xsize()):
		for j in range(land_ca.get_ysize()):
			var chunk_x: int = i / _block_size
			var chunk_y: int = j / _block_size
			
			if chunk_ca.get_cell(chunk_x, chunk_y) == 1:
				house_ca.set_cell(i, j, randi_range(1, 3))
				
				if randf() < 0.01:
					if denizen_prefab:
						var denizen: Node = denizen_prefab.duplicate()
						denizen.global_position = Vector3(i + randf_range(-5, 5), j + randf_range(-5, 5), 0)
						if denizen_parent:
							denizen_parent.add_child(denizen)
	
	house_ca.set_ruleset(_rulesets["house"])
	house_ca.update_iterations(5)
	
	print("finished settlement generation !")


func _generate_environmental_props() -> void:
	print("starting environmental prop generation ...")
	
	for i in range(land_ca.get_xsize()):
		for j in range(land_ca.get_ysize()):
			# If the cell is in the forest range, seed the forest CA
			if land_ca.get_cell(i, j) > 3 and land_ca.get_cell(i, j) < 7:
				forest_ca.set_cell(i, j, randi_range(1, forest_ca.num_states))
	
	forest_ca.update_iterations(2)
	
	print("finished environmental prop generation !")
