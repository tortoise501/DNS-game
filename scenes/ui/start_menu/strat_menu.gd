extends Control

const SETTINGS_FILE = "user://settings.cfg"

func _ready():
	load_settings()

func load_settings():
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_FILE)

	if err != OK:
		return

	var music_volume = config.get_value("audio", "music_volume", 1.0)
	var music_mute = config.get_value("audio", "music_mute", false)

	var sfx_volume = config.get_value("audio", "sfx_volume", 1.0)
	var sfx_mute = config.get_value("audio", "sfx_mute", false)

	var fullscreen = config.get_value("video", "fullscreen", false)

	AudioServer.set_bus_volume_db(1,linear_to_db(music_volume))
	AudioServer.set_bus_mute(1,music_mute)
	AudioServer.set_bus_volume_db(2,linear_to_db(sfx_volume))
	AudioServer.set_bus_mute(2,sfx_mute)
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")



func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/start_menu/setting.tscn")



func _on_exit_pressed() -> void:
	get_tree().quit()
