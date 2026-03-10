extends Node2D

var spawn_radius = 100
var spawn_amout = 1

@onready var enemy_pref = preload("res://prefabs/Enemy/enemy.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_enemy():
	for enemy_i in range(spawn_amout):
		var angle = randf_range(0,360)
		var distance = randf_range(0, spawn_radius)
		var enemy_instance: CharacterBody2D = enemy_pref.instantiate()
		enemy_instance.global_position = global_position + Vector2(distance,0).rotated(angle)
		get_node("/root/Node2D").add_child(enemy_instance)
