@tool
class_name IslandSeeder
extends Node2D

@export var spawn_player: bool = false
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
	if tilemap:
		var tilemap_loc: Vector2 = tilemap.map_to_local(island.get_location_chunked())
		global_position = tilemap_loc
		name = island.name + "Seeder" + str(island.location)

func _draw() -> void:
	if Engine.is_editor_hint():
		# Vector2.ZERO is the position relative to this node
		draw_circle(Vector2.ZERO, 200, Color.GREEN)

func _ready() -> void:
	if spawn_player:
		call_deferred("spawn_player_here")

func spawn_player_here() -> void:
	GameManager.player.global_position = global_position
