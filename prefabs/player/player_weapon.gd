extends Node2D

@onready var bullet = preload("res://prefabs/arrow/arrow.tscn")
@onready var simple_bullet_texture = preload("res://prefabs/aim_point/crosshair.png")
@onready var ability_bullet_texture = preload("res://prefabs/aim_point/circle.png")

var ability_used = 0
@onready var aim_point = get_node("/root/Node2D/AimPoint")
@onready var aim_point_sprite: Sprite2D = get_node("/root/Node2D/AimPoint/Sprite2D")

var arrow_rain_count = 50
var arrow_rain_radius = 100
var arrow_rain_height = 200
var arrow_rain_KD = 10000 #msec
var last_time_arrow_rain_used = -100000

var dash_KD = 3000
var last_time_dash_used = -3000

signal shot(int)


func _process(_delta: float) -> void:
	queue_redraw()
	
	if Input.is_action_just_pressed("ability_1"):
		change_ability(1)
	
	if Input.is_action_just_pressed("ability_2"):
		change_ability(2)
		shoot()
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	if last_time_arrow_rain_used + arrow_rain_KD < Time.get_ticks_msec():
		$"../CanvasLayer/Control/AbilityKD1".text = "0"#first ability is ready
	else:
		$"../CanvasLayer/Control/AbilityKD1".text = String("%.1f s" % ((last_time_arrow_rain_used + arrow_rain_KD - Time.get_ticks_msec())/1000.0))
		
	if last_time_dash_used + dash_KD < Time.get_ticks_msec():
		$"../CanvasLayer/Control/AbilityKD2".text = "0"#first ability is ready
	else:
		$"../CanvasLayer/Control/AbilityKD2".text = String("%.1f s" % ((last_time_dash_used + dash_KD - Time.get_ticks_msec())/1000.0))	
			
func shoot():
	match ability_used:
		0:
			use_ability0()
		1:
			use_ability1()
		2:
			use_ability2()
			
func use_ability2():
	if last_time_dash_used + dash_KD < Time.get_ticks_msec():
		last_time_dash_used = Time.get_ticks_msec()
		get_parent().dash()
	change_ability(0)
				
func use_ability1():
	if last_time_arrow_rain_used + arrow_rain_KD < Time.get_ticks_msec():
		shot.emit(1)
		last_time_arrow_rain_used = Time.get_ticks_msec()
		for i in range(arrow_rain_count):
			var angle = randf_range(0,360)
			var distance = randf_range(0, arrow_rain_radius)
			spawn_bullet(
				50,
				get_global_mouse_position() + Vector2(distance,0).rotated(angle) + Vector2(0,-arrow_rain_height),
				Vector2.DOWN,
				arrow_rain_height)
		
		change_ability(0)
		

func use_ability0():
	shot.emit(0)
	var to_mouse_vector: Vector2 = get_global_mouse_position() - global_position
	spawn_bullet(
		350,
		self.global_position + to_mouse_vector.normalized() * 50,
		to_mouse_vector.normalized())
	

func change_ability(to_ability: int):
	if ability_used != to_ability:
		ability_used = to_ability
	else:
		ability_used = 0
	
	match ability_used:
		0:
			aim_point_sprite.texture = simple_bullet_texture
			aim_point_sprite.scale = Vector2.ONE
		1:
			aim_point_sprite.texture = ability_bullet_texture
			var texture_width = aim_point_sprite.texture.get_width()
			var scale_coof = (arrow_rain_radius * 4.0) / texture_width
			aim_point_sprite.scale = Vector2.ONE * scale_coof
	
func _draw() -> void:
	draw_line($".".position,get_local_mouse_position(),Color.WHITE)

func spawn_bullet(damage, pos, look_at_vec_mod, life_span = 0):
	var bullet_instance:RigidBody2D = bullet.instantiate()
	bullet_instance.global_position = pos
	bullet_instance.look_at(bullet_instance.global_position + look_at_vec_mod)
	if life_span != 0:
		bullet_instance.life_span = life_span
	bullet_instance.damage = damage
	get_node("/root/Node2D").add_child(bullet_instance)
	pass
