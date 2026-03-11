extends CharacterBody2D

@export var movement_speed: float = 100.0
var movement_target_position: Vector2 = Vector2.ZERO
@onready var player: Node2D

@export var enemy_tier := 1

@export var maxHP := 1000
var currentHP = maxHP
var active = true

@onready var attack_pref = preload("res://prefabs/enemy_attack/attack.tscn")
@export var attack_distance := 75
var attack_distance_max_diff = 20
@export var attack_damage := 10
@export var attack_time := 500 #in msec
var last_attack_time = 0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

@onready var animation_handler = $AnimatedSprite2D

signal enemy_died
@onready var ghost_pref = preload("res://prefabs/ghost/ghost.tscn")


func _ready():
	update_hp_label()
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	if !player:
		player = get_parent().player
	
	if !active:
		return
	if !navigation_agent.is_navigation_finished() && (player.global_position - global_position).length() > attack_distance - attack_distance_max_diff:
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()

		velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	else:
		velocity = Vector2.ZERO
	if velocity.x >= 0:
		animation_handler.flip_h = false
	else:
		animation_handler.flip_h = true
		
		
	move_and_slide()
	set_movement_target(player.global_position)
	
func _process(delta: float) -> void:
	if !active:
		return
	var player_pos = get_parent().player.global_position
	if last_attack_time + attack_time < Time.get_ticks_msec() && (player_pos - global_position).length() < attack_distance:
		last_attack_time = Time.get_ticks_msec()
		attack(player_pos)
		animation_handler.play("shoot")
	elif !animation_handler.is_playing() && active:
		if velocity != Vector2.ZERO:
			animation_handler.play("run")
		if velocity == Vector2.ZERO:
			animation_handler.play("idle")
		
func attack(player_pos):
	var attack_inst = attack_pref.instantiate()
	attack_inst.damage = attack_damage
	attack_inst.global_position = (global_position + player_pos)/2
	attack_inst.look_at(player_pos)
	get_node("/root/Node2D").add_child(attack_inst)
	pass


func get_hit(damage):
	currentHP -= damage
	if active && currentHP <= 0:
		currentHP = 0
		active = false
		animation_handler.play("death")
		$CollisionShape2D.set_deferred("disabled",true)
		var ghost_inst:Node2D = ghost_pref.instantiate()
		ghost_inst.global_position = global_position + Vector2.UP * 20
		get_node("/root/Node2D").add_child(ghost_inst)
		enemy_died.emit(enemy_tier)
	update_hp_label()


func update_hp_label():
	if active:
		$HPLabel.text = "%d/%d" % [currentHP, maxHP]
	else:
		$HPLabel.set_deferred("visible",false)


func _on_animated_sprite_2d_animation_finished() -> void:
	if !active:
		queue_free()
	pass # Replace with function body.
