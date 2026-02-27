# Wearable item that can be equipped
extends Item
class_name Wearable

enum WearableSlot {
	HEAD,
	CHEST,
	LEGS,
	FEET,
	WEAPON,
	SHIELD,
	NECK,
	FINGER
}

@export var slot: WearableSlot = WearableSlot.HEAD
@export var armour_modifier: float = 0.0
@export var damage_modifier: float = 0.0

func use() -> void:
	GameManager.player.wearable_manager.equip(self)
	remove_from_inventory()
