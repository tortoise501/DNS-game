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

	$music.value = music_volume
	$music_m.button_pressed = music_mute

	$sfx.value = sfx_volume
	$sfx_m.button_pressed = sfx_mute

	$fullscreen.button_pressed = fullscreen

	_on_music_value_changed(music_volume)
	_on_music_m_toggled(music_mute)
	_on_sfx_value_changed(sfx_volume)
	_on_sfx_m_toggled(sfx_mute)
	_on_fullscreen_toggled(fullscreen)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/start_menu/strat_menu.tscn")	

func _on_music_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(1,db)
	save_settings()

func _on_music_m_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(1,toggled_on)
	save_settings()

func _on_sfx_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(2,db)
	save_settings()

func _on_sfx_m_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(2,toggled_on)
	save_settings()
  
func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	save_settings()

func save_settings():
	var config = ConfigFile.new()

	config.set_value("audio", "music_volume", $music.value)
	config.set_value("audio", "music_mute", $music_m.button_pressed)

	config.set_value("audio", "sfx_volume", $sfx.value)
	config.set_value("audio", "sfx_mute", $sfx_m.button_pressed)

	config.set_value("video", "fullscreen", $fullscreen.button_pressed)

	config.save(SETTINGS_FILE)
