extends Control

@export var cooldown_time := 5.0

@onready var cooldown = $Cooldown

var time_left = 0.0
var on_cooldown = false

func _process(delta):
	if on_cooldown:
		time_left -= delta
		cooldown.value = time_left / cooldown_time

		if time_left <= 0:
			on_cooldown = false
			cooldown.value = 0

func use_ability():
	if on_cooldown:
		return

	print("Ability used!")

	on_cooldown = true
	time_left = cooldown_time
	cooldown.value = 1


func _on_button_pressed() -> void:
	use_ability()
