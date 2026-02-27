# StatPool.gd
extends Node
class_name StatPool

@export var stat: Stat  # The stat that this pool is based on, e.g. health, stamina, mana
@onready var current_value: float = 0.0:
    set(val):
        # Ensure value never goes below 0 or above the Stat's current value
        current_value = clamp(val, 0, stat.get_value())
        pool_changed.emit(current_value, stat.get_value())

signal pool_changed(current: float, max: float)
signal emptied

func _ready() -> void:
    # Set to max on start
    current_value = stat.get_value()

func consume(amount: float) -> void:
    current_value -= amount
    if current_value <= 0:
        emptied.emit()

func restore(amount: float) -> void:
    current_value += amount

func fully_restore() -> void:
    current_value = stat.get_value()

func is_empty() -> bool:
    return current_value <= 0