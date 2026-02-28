# 2D Cellular Automaton
class_name CA2D


var num_states: int
var gen_count: int = 0
var _rule_set: PackedInt32Array = PackedInt32Array()
var cells: PackedInt32Array = PackedInt32Array()
var _buffer: PackedInt32Array = PackedInt32Array()
var x_size: int = 0
var y_size: int = 0

# Public property for rule_set access
var rule_set: PackedInt32Array:
	get:
		return _rule_set
	set(value):
		_rule_set = PackedInt32Array(value)


func _init(p_num_states: int, p_size: int) -> void:
	_init_sized(p_num_states, p_size, p_size)


func _init_sized(p_num_states: int, p_x_size: int, p_y_size: int) -> void:
	num_states = p_num_states
	x_size = p_x_size
	y_size = p_y_size
	var total_cells: int = p_x_size * p_y_size
	cells = PackedInt32Array()
	cells.resize(total_cells)
	_buffer = PackedInt32Array()
	_buffer.resize(total_cells)
	_rule_set.resize(num_states * 8)
	gen_count = 0


func update() -> void:
	var x: int = 0
	var y: int = 0
	
	for idx in range(cells.size()):
		y = idx % y_size
		x = idx / y_size
		
		var tot: int = 0
		# Iterate over 3x3 kernel
		for dx in range(-1, 2):
			for dy in range(-1, 2):
				if dx == 0 and dy == 0:
					continue
				var nx: int = (x + dx + x_size) % x_size
				var ny: int = (y + dy + y_size) % y_size
				tot += cells[nx * y_size + ny]
		
		# Clamp neighbor total to valid range to handle cell values > num_states
		_buffer[idx] = _rule_set[min(tot, _rule_set.size() - 1)]
	
	# Swap arrays
	var temp: PackedInt32Array = cells
	cells = _buffer
	_buffer = temp
	gen_count += 1


func update_iterations(iterations: int) -> void:
	for _i in range(iterations):
		update()


func get_cell(x: int, y: int) -> int:
	if x >= 0 and x < x_size and y >= 0 and y < y_size:
		return cells[x * y_size + y]
	return 0


func get_xsize() -> int:
	return x_size


func get_ysize() -> int:
	return y_size


func get_live_neighbours(x: int, y: int) -> int:
	var tot: int = 0
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			if dx == 0 and dy == 0:
				continue
			var nx: int = x + dx
			var ny: int = y + dy
			if nx >= 0 and nx < x_size and ny >= 0 and ny < y_size:
				if cells[nx * y_size + ny] > 0:
					tot += 1
	return tot


func set_cell(x: int, y: int, state: int) -> void:
	if x >= 0 and x < x_size and y >= 0 and y < y_size:
		cells[x * y_size + y] = state


func set_random_states(p: float = 0.5) -> void:
	for i in range(x_size):
		for j in range(y_size):
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
	for i in range(cells.size()):
		cells[i] = 0
