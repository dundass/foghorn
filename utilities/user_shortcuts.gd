# User shortcut handlers for camera and world map
extends Node


@export var main_camera: Camera3D

var showing_world_map: bool = false


func _process(_delta: float) -> void:
	# Commented functionality - enable as needed
	# if Input.is_action_just_pressed("ui_right_click"):
	#	showing_world_map = !showing_world_map
	#	main_camera.fov = 180.0 if showing_world_map else 5.0
	pass
