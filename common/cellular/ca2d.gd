# 2D Cellular Automaton
class_name CA2D


var num_states: int
var gen_count: int = 0
var rule_set: Array[int] = []
var cells: Array[Array] = []
var _buffer: Array[Array] = []
var neighbour_totals: Array[Array] = []


func _init(p_num_states: int, p_size: int) -> void:
	_init_sized(p_num_states, p_size, p_size)


func _init_sized(p_num_states: int, p_x_size: int, p_y_size: int) -> void:
	num_states = p_num_states
	cells = _create_2d_array(p_x_size, p_y_size, 0)
	_buffer = _create_2d_array(p_x_size, p_y_size, 0)
	neighbour_totals = _create_2d_array(p_x_size, p_y_size, 0)
	rule_set.resize(num_states * 8)
	gen_count = 0


func _create_2d_array(x_size: int, y_size: int, initial_value: int) -> Array[Array]:
	var arr: Array[Array] = []
	for i in range(x_size):
		var row: Array = []
		row.resize(y_size)
		for j in range(y_size):
			row[j] = initial_value
		arr.append(row)
	return arr


func update() -> void:
	var x_size = get_xsize()
	var y_size = get_ysize()
	
	for i in range(x_size):
		for j in range(y_size):
			var tot = 0
			# Iterate over 3x3 kernel
			for k in range(i - 1, i + 2):
				for l in range(j - 1, j + 2):
					var m = k if k >= 0 else x_size + k
					m = m % x_size
					var n = l if l >= 0 else y_size + l
					n = n % y_size
					if not (i == k and j == l):
						tot += cells[m][n]
			
			neighbour_totals[i][j] = tot
			for r in range(rule_set.size()):
				if tot == r:
					_buffer[i][j] = rule_set[r]
					break
	
	# Swap arrays
	var temp = cells
	cells = _buffer
	_buffer = temp
	gen_count += 1


func update_iterations(iterations: int) -> void:
	for _i in range(iterations):
		update()


func get_cell(x: int, y: int) -> int:
	if x >= 0 and x < cells.size() and y >= 0 and y < cells[x].size():
		return cells[x][y]
	return 0


func get_xsize() -> int:
	return cells.size()


func get_ysize() -> int:
	if cells.size() > 0:
		return cells[0].size()
	return 0


func get_live_neighbours(x: int, y: int) -> int:
	var tot = 0
	for i in range(-1, 2):
		for j in range(-1, 2):
			if x + i < 0 or x + i >= get_xsize() or y + j < 0 or y + j >= get_ysize():
				continue
			if cells[x + i][y + j] > 0:
				tot += 1
	return tot


func set_cell(x: int, y: int, state: int) -> void:
	if x >= 0 and x < cells.size() and y >= 0 and y < cells[x].size():
		cells[x][y] = state


func set_random_states(p: float = 0.5) -> void:
	var rnd = RandomNumberGenerator.new()
	rnd.seed = hash(Time.get_ticks_msec())
	
	for i in range(get_xsize()):
		for j in range(get_ysize()):
			var r = rnd.randf()
			if r < p:
				set_cell(i, j, 1 + rnd.randi() % (num_states - 1))
			else:
				set_cell(i, j, 0)


func set_lambda_ruleset(p: float = 0.38) -> void:
	var rnd = RandomNumberGenerator.new()
	rnd.seed = hash(Time.get_ticks_msec())
	
	rule_set[0] = 0
	for i in range(1, rule_set.size()):
		var r = rnd.randf()
		if r < p:
			var roll = rnd.randf()
			for j in range(num_states - 1):
				if roll > float(j) / num_states and roll < float(j + 1) / num_states:
					rule_set[i] = j + 1
					break
		else:
			rule_set[i] = 0


func clear() -> void:
	for i in range(get_xsize()):
		for j in range(get_ysize()):
			set_cell(i, j, 0)
