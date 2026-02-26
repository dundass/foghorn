# Manager for equipped wearables
extends Node
class_name WearableManager


signal wearables_changed(new_item: Wearable, old_item: Wearable)

var _currently_worn: Array[Wearable] = []
var _player_inventory: Inventory

static var _instance: WearableManager


func _ready() -> void:
	_instance = self
	
	if GameManager.get_instance() and GameManager.get_instance().player_stats:
		_player_inventory = GameManager.get_instance().player_stats.inventory
	
	var num_slots = Wearable.WearableSlot.size()
	_currently_worn.resize(num_slots)


static func get_instance() -> WearableManager:
	return _instance


func equip(new_item: Wearable) -> void:
	var slot_index = int(new_item.slot)
	
	var old_item: Wearable = null
	
	if slot_index < _currently_worn.size() and _currently_worn[slot_index] != null:
		old_item = _currently_worn[slot_index]
		if _player_inventory:
			_player_inventory.add(old_item)
	
	wearables_changed.emit(new_item, old_item)
	
	if slot_index < _currently_worn.size():
		_currently_worn[slot_index] = new_item


func unequip(slot_index: int) -> void:
	if slot_index < _currently_worn.size() and _currently_worn[slot_index] != null:
		var old_item = _currently_worn[slot_index]
		if _player_inventory:
			_player_inventory.add(old_item)
		
		_currently_worn[slot_index] = null
		
		wearables_changed.emit(null, old_item)
