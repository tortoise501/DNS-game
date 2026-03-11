extends Node2D

var save_path := "user://score.score"

var game_on = true

@onready var player = $Player

var score = 0

@onready var enemy_spawners = [$EnemySpawnerSW,$EnemySpawnerSE,$EnemySpawnerNE,$EnemySpawnerNW]

@onready var enemies = [
	preload("res://prefabs/Enemy/enemy_skeleton.tscn"),
	preload("res://prefabs/Enemy/enemy_mushroom.tscn"),
	preload("res://prefabs/Enemy/enemy_eye.tscn"),
]
@onready var enemies_spawn_chances = [
	[100,0,0],
	[80,20,0],
	[50,35,15]
]


@onready var buffs = [
	preload("res://prefabs/buffs/heal_buff.tscn"),
	preload("res://prefabs/buffs/coin_buff.tscn"),
	preload("res://prefabs/buffs/speed_buff.tscn"),
	preload("res://prefabs/buffs/bomb_buff.tscn"),
]
@onready var explosion_pref = preload("res://prefabs/buffs/explosion.tscn")
@export var buff_spawn_chance_per_tier := 10

#spawns / sec
var start_spawn_rate = 0.2
var max_spawn_rate = 1
var time_to_max_spawnrate = 60 #sec

var enemy_count = 0
var max_enemy_count = 50

func get_current_spawn_progress():
	var time_passed = Time.get_ticks_msec() / 1000.0
	return min(1.0, time_passed / float(time_to_max_spawnrate))

func get_current_spawn_rate():
	var increase_span = max_spawn_rate - start_spawn_rate
	var coof = get_current_spawn_progress()
	return coof * increase_span

func get_current_spawn_chance():
	var chances = enemies_spawn_chances.size() - 1
	var spawn_chance = floor(chances * get_current_spawn_progress())
	return spawn_chance
	
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
	if !game_on:
		return
	var time_between_enemy_queue = (1 / get_current_spawn_rate()) * 1000
	if last_time_enemy_queue + time_between_enemy_queue < Time.get_ticks_msec():
		enemies_queued += 1
		last_time_enemy_queue = Time.get_ticks_msec()
	
	if last_time_enemy_spawn + time_between_enemy_spawn < Time.get_ticks_msec():
		while enemies_queued > 0:
			if max_enemy_count > enemy_count:
				var spawner_id = randi_range(0,enemy_spawners.size() - 1)
				var chance_i = get_current_spawn_chance()
				var used_chance = 0
				var enemy_spawn_i = 0
				for i in range(enemies_spawn_chances[chance_i].size()):
					var dice = randi_range(0,100 - used_chance)
					if dice < enemies_spawn_chances[chance_i][i]:
						enemy_spawn_i = i
				enemy_spawners[spawner_id].spawn_enemy(enemies[enemy_spawn_i])
				enemies_queued -= 1
			else:
				break
		last_time_enemy_spawn = Time.get_ticks_msec()


func _on_child_entered_tree(node: Node) -> void:
	if node.is_in_group("Enemy"):
		enemy_count += 1
		node.enemy_died.connect(_on_enemy_died)

func _on_enemy_died(tier, pos):
	var chance = buff_spawn_chance_per_tier * tier
	var dice = randi_range(0,100)
	if dice < chance:
		var i = randi_range(0,buffs.size() - 1)
		var buff: Node2D = buffs[i].instantiate()
		buff.global_position = pos
		add_child(buff)
	enemy_count -= 1
	score += tier
	update_score_label()

func update_score_label():
	$CanvasLayer/Control/ScoreLabel.text = String("score: %d" % score)


func pick_up_coin(strength):
	score += strength
	update_score_label()

func explode(strength,radius,pos):
	var explosion_inst:Node2D = explosion_pref.instantiate()
	explosion_inst.global_position = pos
	explosion_inst.scale *= radius/2
	explosion_inst.strength = strength
	add_child(explosion_inst)


func _on_player_game_over() -> void:
	game_on = false
	var children = get_children()
	for child in children:
		if child.has_method("freeze"):
			child.freeze()
	print("GAME OVER")
	save_best_score()
	pass # Replace with function body.

func save_best_score():
	var file = FileAccess.open(save_path, FileAccess.READ)
	var best_score = file.get_32()
	if best_score < score:
		best_score = score
	
	
	#print(best_score)
	#if best_score < score:
		#file.store_32(score)
	#file.close()
