extends Node2D
class_name BaseLevel

@onready var sun_manager: SunController = $SunController
@onready var weather_manager: WeatherController = $WeatherController
@onready var camera: CameraController = $CameraController
@onready var tilemap: TileMapLayer = $TileMapLayer
@onready var entities: Node2D = $"Entities"
