# Animal agent
extends Agent
class_name Animal

enum AnimalReactions {
	FIGHT,
	FLIGHT
}

# var idle_behaviour
# var attack_behaviour  
var reaction: AnimalReactions = AnimalReactions.FIGHT
# var drops = []  # How to implement chances?