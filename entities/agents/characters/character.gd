# Character agent with multiple attributes
extends Agent
class_name Character

var agendas: Array[Agenda] = []
var heritage: Array[IslandData] = []
var trusts: Array[Agent] = []
var inventory: Inventory
