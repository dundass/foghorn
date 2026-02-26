# Manages player interactions with interactable objects
extends Node
class_name InteractionManager

var _focussed_interactable: Node

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and can_interact():
		initiate_interaction()


func can_interact() -> bool:
	return _focussed_interactable != null


func initiate_interaction() -> void:
	if _focussed_interactable and _focussed_interactable is Interactable:
		_focussed_interactable.interact()


func _on_trigger_enter(area: Area3D) -> void:
	if area.is_in_group("Interactable"):
		_focussed_interactable = area
		if _focussed_interactable is Interactable:
			pass


func _on_trigger_exit(area: Area3D) -> void:
	if area.is_in_group("Interactable"):
		if _focussed_interactable == area:
			_focussed_interactable = null
