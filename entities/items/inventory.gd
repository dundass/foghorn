# Inventory container for managing items
extends Node
class_name Inventory


signal item_changed

var items: Array[Item] = []


func add(item: Item) -> void:
	items.append(item)
	item_changed.emit()


func remove(item: Item) -> void:
	items.erase(item)
	item_changed.emit()
