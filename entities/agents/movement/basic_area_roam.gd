# Basic area roaming behavior for animals
# Thank you, happy harvest :)
extends Node2D


@export var area: Area2D
@export var min_idle_time: float = 0.0
@export var max_idle_time: float = 1.0
@export var speed: float = 2.0

@export var animal_sound: Array[AudioStream] = []
@export var min_random_sound_time: float = 1.0
@export var max_random_sound_time: float = 5.0

var _idle_timer: float = 0.0
var _current_idle_target: float = 0.0
var _sound_timer: float = 0.0
var _current_target: Vector2 = Vector2.ZERO
var _is_idle: bool = false
var _animator: AnimationPlayer

func _ready() -> void:
	if max_idle_time <= min_idle_time:
		max_idle_time = min_idle_time + 0.1
	
	_animator = get_node_or_null("AnimationPlayer")
	_sound_timer = randf_range(min_random_sound_time, max_random_sound_time)
	
	_is_idle = true
	_pick_new_idle_time()


func _process(delta: float) -> void:
	_sound_timer -= delta
	if _sound_timer <= 0.0:
		# SoundManager.get_instance().play_sfx_at(global_position, animal_sound[randi() % animal_sound.size()], true)
		_sound_timer = randf_range(min_random_sound_time, max_random_sound_time)
	
	if _is_idle:
		_idle_timer += delta
		
		if _idle_timer >= _current_idle_target:
			_pick_new_target()
	else:
		global_position = global_position.move_toward(_current_target, speed * delta)
		if global_position == _current_target:
			_pick_new_idle_time()


func _pick_new_idle_time() -> void:
	if _animator != null:
		_animator.set_float("parameters/Speed", 0.0)
	
	_is_idle = true
	_current_idle_target = randf_range(min_idle_time, max_idle_time)
	_idle_timer = 0.0


func _pick_new_target() -> void:
	_is_idle = false
	
	var angle: float = randf() * TAU
	var direction: Vector2 = Vector2(cos(angle), sin(angle))
	direction *= randf_range(1.0, 10.0)
	
	var pos: Vector2 = Vector2(global_position.x, global_position.y)
	var target_point: Vector2 = pos + direction
	
	if area and not area.get_overlapping_areas().is_empty():
		# Use area's closest point if available
		pass
	
	_current_target = Vector2(target_point.x, target_point.y)
	
	var to_target: Vector2 = _current_target - global_position
	var flipped: bool = to_target.x < 0
	
	scale.x = -1.0 if flipped else 1.0
	
	if _animator != null:
		_animator.set_float("parameters/Speed", speed)
