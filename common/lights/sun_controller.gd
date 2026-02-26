class_name SunController
extends Node

@export var light_offset: float = 1.0
@export var light_amplitude: float = 0.5
@export var light_limit: float = 1.0
@export var sun_light: Light2D

var world_clock: WorldClock

func _ready() -> void:
	world_clock = GameManager.world_clock
	EventBus.time_changed.connect(_update_light)

func _update_light(time: int) -> void:
	var intensity: float = light_offset + (sin(time * 6.33 / world_clock.day_length) * light_amplitude)
	sun_light.light_energy = min(intensity, light_limit)
