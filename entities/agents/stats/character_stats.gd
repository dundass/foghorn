# Character statistics and health management
extends Node
class_name CharacterStats

@export var health: StatPool

var damage: Stat = Stat.new()
var armour: Stat = Stat.new()

var strength: Stat = Stat.new() # melee attack, carrying capacity, tool use
var dexterity: Stat = Stat.new() # ranged attack, evasion, lockpicking
var constitution: Stat = Stat.new() # health, stamina, resistance to poisons/diseases ?
var intelligence: Stat = Stat.new() # magic power, crafting skill, puzzle-solving ?
var wisdom: Stat = Stat.new() # magic defense, perception, survival skills ?
var charisma: Stat = Stat.new() # bartering, persuasion, likeability

var is_alive: bool = true

func restore_health(amount: float) -> void:
	health.restore(amount)

func take_damage(amount: float) -> void:
	amount -= armour.get_value()
	amount = max(0, amount)  # Prevent healing from negative damage
	
	health.consume(amount)
	
	if health.is_empty():
		die()


func die() -> void:
	is_alive = false
	print(get_parent().name + " died")
	get_parent().queue_free()
