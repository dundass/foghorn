# Container interactable for items
extends Interactable
class_name ContainerInteractable

var _items: Array[Item] = []
var _inventory: Inventory

func _ready() -> void:
	_inventory = Inventory.new()
	
	for item in _items:
		_inventory.add(item)


func interact(_target: Node = null) -> void:
	# Open container and player inventory UI
	pass
