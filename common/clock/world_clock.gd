# World clock for managing day/night cycles
class_name WorldClock
extends Node

@export var day_length: int = 10000
@export var night_threshold: int = 6666

var time: int = 0

func _ready() -> void:
	GameManager.world_clock = self
	time = 0

func _process(_delta: float) -> void:
	time += 1
	EventBus.time_changed.emit(time)
	EventBus.time_changed_percent.emit(float(time % day_length) / day_length)
	
	if time % day_length == 0:
		EventBus.day_started.emit()
		print("cockadoodledoo")
	elif time % day_length == night_threshold:
		EventBus.night_started.emit()

func is_daytime() -> bool:
	return time % day_length < night_threshold
