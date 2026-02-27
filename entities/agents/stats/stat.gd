# Stat with modifiers
class_name Stat
extends Resource

@export var base_value: float = 0.0

var _modifiers: Array[float] = []
var _is_dirty: bool = true
var _cached_value: float = 0.0

func get_value() -> float:
    if _is_dirty:
        _cached_value = base_value
        for mod in _modifiers:
            _cached_value += mod
        _is_dirty = false
    return _cached_value

func add_modifier(mod: float) -> void:
    _modifiers.append(mod)
    _is_dirty = true

# It is safer to remove by index or use a unique ID/Object for modifiers
func remove_modifier(mod: float) -> void:
    var idx: int = _modifiers.find(mod)
    if idx != -1:
        _modifiers.remove_at(idx)
        _is_dirty = true