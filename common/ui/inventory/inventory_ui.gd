# Inventory UI display
extends Control
class_name InventoryUI


@export var items_parent: Container
@export var test_item_sprite: Texture2D
@export var test_item: Consumable

var _inventory: Inventory
var _slots: Array[InventorySlot] = []


func _ready() -> void:
	var player_node = get_tree().root.find_child("Player", true, false)
	if player_node:
		_inventory = player_node.get_node_or_null("Inventory")
		if _inventory:
			_inventory.item_changed.connect(_on_inventory_changed)
	
	if items_parent:
		var children: Array[Node] = items_parent.get_children()
		_slots = children.filter(func(x): return x is InventorySlot)
	
	if _inventory and test_item:
		_inventory.add(test_item)


func _process(_delta: float) -> void:
	# Poll inventory keyboard input to toggle here
	pass


func toggle_inventory() -> void:
	if items_parent:
		items_parent.visible = !items_parent.visible


func _on_inventory_changed() -> void:
	_update_ui()


func _update_ui() -> void:
	if not _inventory:
		return
	
	for i in range(_slots.size()):
		if i < _inventory.items.size():
			_slots[i].add_item(_inventory.items[i])
		else:
			_slots[i].clear_slot()
