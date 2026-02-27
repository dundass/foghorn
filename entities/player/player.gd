class_name Player
extends Node

var stats: PlayerStats
var inventory: Inventory
var wearable_manager: WearableManager

func _ready() -> void:
    GameManager.player = self