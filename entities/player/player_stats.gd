# Player-specific statistics
extends CharacterStats
class_name PlayerStats

var inventory: Inventory

func _ready() -> void:
	super._ready()
	
	GameManager.player_stats = self
	
	if WearableManager.get_instance():
		WearableManager.get_instance().wearables_changed.connect(_on_wearables_changed)

func _on_wearables_changed(new_item: Wearable, old_item: Wearable) -> void:
	if new_item != null:
		# armour.add_modifier(new_item.armour_modifier)
		# damage.add_modifier(new_item.damage_modifier)
		pass
	
	if old_item != null:
		# armour.remove_modifier(old_item.armour_modifier)
		# damage.remove_modifier(old_item.damage_modifier)
		pass
