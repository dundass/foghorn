# Cellular automaton texture generator
extends Node


var _ca: CA2D
var _sprite_renderer: Sprite3D


func _ready() -> void:
	_ca = CA2D.new(32, 32)
	_ca.set_lambda_ruleset()
	_ca.set_random_states()
	_ca.update_iterations(3)
	
	_sprite_renderer = get_node_or_null("Sprite3D")
	
	var image = Image.create(32, 32, false, Image.FORMAT_RGB8)
	
	for i in range(image.get_width()):
		for j in range(image.get_height()):
			var cell_val = _ca.get_cell(i, j)
			var color = Color(
				float(cell_val) / 255.0,
				float(60 - cell_val) / 255.0,
				float(50 + cell_val * 2) / 255.0,
				1.0
			)
			image.set_pixel(i, j, color)
	
	var texture = ImageTexture.create_from_image(image)
	
	if _sprite_renderer:
		_sprite_renderer.texture = texture
