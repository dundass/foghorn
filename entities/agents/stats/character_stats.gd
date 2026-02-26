# Character statistics and health management
extends Node
class_name CharacterStats


@export var max_health: int = 100
var current_health: int

var damage: Stat = Stat.new()
var armour: Stat = Stat.new()


func _ready() -> void:
	current_health = max_health


func take_damage(damage_amount: int) -> void:
	damage_amount -= int(armour.get_value())
	damage_amount = max(0, damage_amount)  # Prevent healing from negative damage
	
	current_health -= damage_amount
	
	if current_health <= 0:
		die()


func die() -> void:
	print(get_parent().name + " died")
	get_parent().queue_free()
