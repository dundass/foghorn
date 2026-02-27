# Manager for equipped wearables
extends Node
class_name WearableManager

signal wearables_changed(new_item: Wearable, old_item: Wearable)

var _currently_worn: Array[Wearable] = []
var _player_inventory: Inventory

func _ready() -> void:
	GameManager.player.wearable_manager = self
	_player_inventory = GameManager.player.inventory
	
	# Initialize the currently worn array with nulls based on the number of wearable slots
	var num_slots: int = Wearable.WearableSlot.size()
	_currently_worn.resize(num_slots)

func equip(new_item: Wearable) -> void:
	# Determine the slot index based on the new item's slot
	var slot_index: int = int(new_item.slot)
	
	var old_item: Wearable = null
	
	# If there's already an item in that slot, unequip it first
	if slot_index < _currently_worn.size() and _currently_worn[slot_index] != null:
		old_item = _currently_worn[slot_index]
		if _player_inventory:
			_player_inventory.add(old_item)
	
	wearables_changed.emit(new_item, old_item)
	
	# Update the currently worn item for that slot
	if slot_index < _currently_worn.size():
		_currently_worn[slot_index] = new_item


func unequip(slot_index: int) -> void:
	if slot_index < _currently_worn.size() and _currently_worn[slot_index] != null:
		var old_item: Wearable = _currently_worn[slot_index]
		if _player_inventory:
			_player_inventory.add(old_item)
		
		_currently_worn[slot_index] = null
		
		wearables_changed.emit(null, old_item)
