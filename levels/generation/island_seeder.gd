@tool
class_name IslandSeeder
extends Node2D

@export var tilemap: TileMapLayer
@export var island: IslandData:
	set(new_island):
		if island != null:
			island.changed.disconnect(_on_resource_changed)
		island = new_island
		# Connect the changed signal as soon as a new island is being added.
		if island != null:
			island.changed.connect(_on_resource_changed)
			# Update position immediately with the new island's location
			_on_resource_changed()

func _on_resource_changed() -> void:
	var flippedY: int = island.location.y * -1
	var tilemap_loc: Vector2 = tilemap.map_to_local(Vector2(island.location.x, flippedY))
	global_position = tilemap_loc
	name = island.name + "Seeder" + str(island.location)