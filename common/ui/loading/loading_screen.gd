extends CanvasLayer

@onready var progress_bar: ProgressBar = $ProgressBar

signal loading_screen_ready

func _ready() -> void:
    loading_screen_ready.emit()

func update_progress(percent: float) -> void:
    progress_bar.value = percent