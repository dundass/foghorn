# Player movement and animation controller
extends Node
class_name PlayerMovement

@export var animator: AnimationPlayer
@export var speed: float = 2.0

func _physics_process(_delta: float) -> void:
	var movement: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	
	if animator:
		animator.set_param("Horizontal", movement.x)
		animator.set_param("Vertical", movement.y)
		animator.set_param("Magnitude", movement.length())
	
	var character_body: CharacterBody2D = get_parent() as CharacterBody2D
	character_body.velocity = movement * speed
	character_body.move_and_slide()
