# Renders world tiles from cellular automata data
extends Node
class_name WorldRenderer


@export var ground_tilemap: Node
@export var overground_tilemap: Node
@export var ground_tiles: Array[Resource] = []
@export var forest_tiles: Array[Resource] = []
@export var mountain_tiles: Array[Resource] = []
@export var house_tiles: Array[Resource] = []
@export var ground_prop_tiles: Array[Resource] = []
@export var forest_prop_tiles: Array[Resource] = []
@export var mountain_prop_tiles: Array[Resource] = []


func render_world(land_ca: CA2D, house_ca: CA2D, forest_ca: CA2D) -> void:
	print("starting batch tile rendering ...")
	
	var x_size = land_ca.get_xsize()
	var y_size = land_ca.get_ysize()
	
	# Pre-allocate lists with estimated capacity
	var ground_positions: Array[Vector3i] = []
	var ground_tiles_list: Array[Resource] = []
	
	var overground_positions: Array[Vector3i] = []
	var overground_tiles_list: Array[Resource] = []
	
	var pos = Vector3i()
	
	# Single pass through all cells
	for i in range(x_size):
		for j in range(y_size):
			pos = Vector3i(i, j, 0)
			var land_cell = land_ca.get_cell(i, j)
			
			# Process ground layer
			if land_cell > 0 and land_cell < 4:
				ground_positions.append(pos)
				if land_cell - 1 < ground_tiles.size():
					ground_tiles_list.append(ground_tiles[land_cell - 1])
			elif land_cell >= 4 and land_cell < 7:
				ground_positions.append(pos)
				if land_cell - 4 < forest_tiles.size():
					ground_tiles_list.append(forest_tiles[land_cell - 4])
			elif land_cell >= 7 and land_cell < 10:
				ground_positions.append(pos)
				if land_cell - 7 < mountain_tiles.size():
					ground_tiles_list.append(mountain_tiles[land_cell - 7])
			
			# Process overground layer
			var house_cell = house_ca.get_cell(i, j)
			if house_cell > 0:
				overground_positions.append(pos)
				if house_cell - 1 < house_tiles.size():
					overground_tiles_list.append(house_tiles[house_cell - 1])
			
			var forest_cell = forest_ca.get_cell(i, j)
			if forest_cell > 0:
				overground_positions.append(pos)
				if forest_cell - 1 < forest_prop_tiles.size():
					overground_tiles_list.append(forest_prop_tiles[forest_cell - 1])
	
	print("finished batch tile rendering !")
