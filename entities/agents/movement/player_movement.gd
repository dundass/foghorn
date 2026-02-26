# Player movement and animation controller
extends Node


@export var animator: AnimationPlayer
@export var speed: float = 2.0


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	var movement = Vector3(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_down", "ui_up"),
		0.0
	)
	
	if animator:
		animator.set_param("Horizontal", movement.x)
		animator.set_param("Vertical", movement.y)
		animator.set_param("Magnitude", movement.length())
	
	get_parent().position += movement * delta * speed
