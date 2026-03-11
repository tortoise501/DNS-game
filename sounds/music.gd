extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func music():
	audio_stream_player.play()
