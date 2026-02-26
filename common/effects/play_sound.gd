# Effect that plays a sound
extends Effect
class_name PlaySound

#@export var audio_source: AudioStreamPlayer
@export var audio_clip: AudioStream


func apply(_target: Node) -> void:
    pass
# 	if audio_source and audio_clip:
# 		audio_source.stream = audio_clip
# 		audio_source.play()
