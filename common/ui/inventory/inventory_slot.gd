# UI slot for displaying inventory items
extends Control
class_name InventorySlot


@export var inspector: Control
@export var icon: TextureRect

var item: Item


func add_item(new_item: Item) -> void:
	item = new_item
	
	if icon:
		icon.texture = new_item.icon
		icon.visible = true


func clear_slot() -> void:
	item = null
	if icon:
		icon.texture = null
		icon.visible = false


func _on_mouse_entered() -> void:
	# On hover item inspector
	if item == null:
		if inspector:
			inspector.visible = false
		return
	
	if inspector:
		inspector.visible = true
		var label = inspector.get_node_or_null("Label")
		if label:
			label.text = item.display_name
