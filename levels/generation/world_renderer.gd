# Renders world tiles from cellular automata data
extends Node
class_name WorldRenderer


@export var ground_tilemap: TileMapLayer
@export var overground_tilemap: TileMapLayer


func render_world(land_ca: CA2D, house_ca: CA2D = null, forest_ca: CA2D = null) -> void:
	print("starting world tile rendering ...")
	
	var x_size: int = land_ca.get_xsize()
	var y_size: int = land_ca.get_ysize()
	
	# Single pass through all cells
	for i in range(x_size):
		for j in range(y_size):
			var pos: Vector2i = Vector2i(i, j)
			var land_cell: int = land_ca.get_cell(i, j)
			
			# Process ground layer - map CA values 1-9 to tile indices 0-8
			if land_cell > 0 and land_cell <= 9:
				var tile_index: int = land_cell - 1
				ground_tilemap.set_cell(pos, 0, Vector2i(tile_index, 0))
			
			# Process overground layer - houses
			if house_ca:
				var house_cell: int = house_ca.get_cell(i, j)
				if house_cell > 0:
					var tile_index: int = house_cell - 1
					overground_tilemap.set_cell(pos, 0, Vector2i(tile_index, 0))
			
			# Process overground layer - forest props
			if forest_ca:
				var forest_cell: int = forest_ca.get_cell(i, j)
				if forest_cell > 0:
					var tile_index: int = forest_cell - 1
					overground_tilemap.set_cell(pos, 0, Vector2i(tile_index, 0))
	
	print("finished world tile rendering!")
