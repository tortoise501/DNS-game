extends Node2D

@onready var player = $Player

@onready var enemy_spawners = [$EnemySpawnerSW]

#TEST ONLY
var time_between_enemy_spawn = 5000 #msec
var last_time_enemy_spawn = -100000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if last_time_enemy_spawn + time_between_enemy_spawn < Time.get_ticks_msec():
		enemy_spawners[0].spawn_enemy()
		last_time_enemy_spawn = Time.get_ticks_msec()
	pass
