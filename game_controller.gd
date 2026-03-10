extends Node2D

@onready var player = $Player

var score = 0

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


func _on_child_entered_tree(node: Node) -> void:
	if node.is_in_group("Enemy"):
		node.enemy_died.connect(_on_enemy_died)

func _on_enemy_died():
	score+=1
	print("score: %d" % score)
	pass
