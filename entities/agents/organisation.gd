# Organization of agents
class_name Organisation

var agendas: Array[Agenda]
var members: Array[Agent]
var age: int


func _init(p_agendas: Array[Agenda], p_members: Array[Agent]) -> void:
	agendas = p_agendas
	members = p_members
	age = 0


func total_wealth() -> float:
	var tot: float = 0.0
	for member in members:
		# if member has Inventory
		pass
	return tot


func membership_size() -> int:
	return members.size()


func update() -> void:
	age += 1
