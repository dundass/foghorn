# 2D Cellular Automaton
class_name CA2D
extends RefCounted

var num_states: int
var gen_count: int = 0

var width: int
var height: int

# Flattened arrays for performance
var cells: PackedInt32Array
var _buffer: PackedInt32Array

var _rule_set: PackedInt32Array
# Public property for rule_set access
var rule_set: PackedInt32Array:
	get:
		return _rule_set
	set(value):
		_rule_set = PackedInt32Array(value)


func _init(p_num_states: int, p_size: int) -> void:
	_init_sized(p_num_states, p_size, p_size)


func _init_sized(p_num_states: int, p_width: int, p_height: int) -> void:
	num_states = p_num_states
	width = p_width
	height = p_height
	
	cells.resize(width * height)
	_buffer.resize(width * height)
	
	# Max total is (num_states - 1) * 8
	_rule_set.resize((num_states * 8) + 1)
	cells.fill(0)
	_buffer.fill(0)
	gen_count = 0


func update() -> void:
	var w := width
	var h := height
	var current_cells := cells
	var next_cells := _buffer
	var rules := _rule_set
	var rules_len := rules.size()

	for y in range(h):
		var y_offset := y * w
		for x in range(w):
			var total := 0
			
			# Neighborhood Check (Toroidal/Wrapping)
			for ny in range(-1, 2):
				# Pre-calculate Y neighbor with wrapping
				var iy := (y + ny + h) % h
				var iy_offset := iy * w
				
				for nx in range(-1, 2):
					if nx == 0 and ny == 0:
						continue
					
					# Fast wrapping for X
					var ix := (x + nx + w) % w
					total += current_cells[iy_offset + ix]
			
			# Apply rule via direct index lookup
			var next_state := 0
			if total < rules_len:
				next_state = rules[total]
			
			next_cells[y_offset + x] = next_state

	# Swap buffer and cells
	cells = next_cells
	_buffer = current_cells
	gen_count += 1


func update_iterations(iterations: int) -> void:
	for _i in range(iterations):
		update()


func set_cell(x: int, y: int, state: int) -> void:
	cells[y * width + x] = state

func get_cell(x: int, y: int) -> int:
	return cells[y * width + x]


func get_xsize() -> int:
	return width


func get_ysize() -> int:
	return height


func get_live_neighbours(x: int, y: int) -> int:
	var tot: int = 0
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			if dx == 0 and dy == 0:
				continue
			var nx: int = x + dx
			var ny: int = y + dy
			if nx >= 0 and nx < width and ny >= 0 and ny < height:
				if cells[nx * height + ny] > 0:
					tot += 1
	return tot


func set_random_states(p: float = 0.5) -> void:
	for i in range(width):
		for j in range(height):
			var r: float = randf()
			if r < p:
				set_cell(i, j, 1 + randi() % (num_states - 1))
			else:
				set_cell(i, j, 0)

func set_ruleset(ruleset: Array) -> void:
	_rule_set = PackedInt32Array(ruleset)

func set_lambda_ruleset(p: float = 0.38) -> void:
	_rule_set[0] = 0
	for i in range(1, _rule_set.size()):
		var r: float = randf()
		if r < p:
			var roll: float = randf()
			for j in range(num_states - 1):
				if roll > float(j) / num_states and roll < float(j + 1) / num_states:
					_rule_set[i] = j + 1
					break
		else:
			_rule_set[i] = 0


func clear() -> void:
	cells.fill(0)
	_buffer.fill(0)
