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


func use() -> void:
	if WearableManager.get_instance():
		WearableManager.get_instance().equip(self)
		remove_from_inventory()
