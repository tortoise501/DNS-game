extends Node2D

@onready var player = $Player

var score = 0

@onready var enemy_spawners = [$EnemySpawnerSW]

#spawns / sec
var start_spawn_rate = 0.2
var max_spawn_rate = 4
var time_to_max_spawnrate = 360 #sec

var enemy_count = 0
var max_enemy_count = 50


func get_current_spawn_rate():
	var increase_span = max_spawn_rate - start_spawn_rate
	var time_passed = Time.get_ticks_msec() / 1000.0
	var coof = min(1.0, time_passed / float(time_to_max_spawnrate))
	return coof * increase_span
	
var enemies_queued = 0

var last_time_enemy_spawn = -100000
var time_between_enemy_spawn = 5000
var last_time_enemy_queue = -100000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_score_label()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var time_between_enemy_queue = (1 / get_current_spawn_rate()) * 1000
	if last_time_enemy_queue + time_between_enemy_queue < Time.get_ticks_msec():
		enemies_queued += 1
		last_time_enemy_queue = Time.get_ticks_msec()
	
	if last_time_enemy_spawn + time_between_enemy_spawn < Time.get_ticks_msec():
		while enemies_queued > 0:
			if max_enemy_count > enemy_count:
				enemy_spawners[0].spawn_enemy()
				enemies_queued -= 1
			else:
				break
		last_time_enemy_spawn = Time.get_ticks_msec()


func _on_child_entered_tree(node: Node) -> void:
	if node.is_in_group("Enemy"):
		enemy_count += 1
		node.enemy_died.connect(_on_enemy_died)

func _on_enemy_died():
	enemy_count -= 1
	score += 1
	update_score_label()

func update_score_label():
	$CanvasLayer/Control/ScoreLabel.text = String("score: %d" % score)
