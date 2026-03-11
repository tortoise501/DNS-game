extends Node2D

var flip_time = 600#msec
var fade_time = 1000.0#msec
@onready var time_spawned = Time.get_ticks_msec()
@onready var time_last_flipped = Time.get_ticks_msec()
var speed = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	translate(Vector2.UP * speed * delta)
	if time_last_flipped + flip_time < Time.get_ticks_msec():
		time_last_flipped = Time.get_ticks_msec()
		$Sprite2D.flip_h = !$Sprite2D.flip_h
	var a = 1.0 - get_fade_val()
	$Sprite2D.modulate.a = a
	if a == 0:
		queue_free()
	pass

func get_fade_val() -> float:
	var diff = Time.get_ticks_msec() - time_spawned
	return diff / fade_time
