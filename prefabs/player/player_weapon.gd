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

func _physics_process(_delta: float) -> void:
	queue_redraw()
	
	if Input.is_action_just_pressed("ability_1"):
		change_ability(1)
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
				
				
func shoot():
	var to_mouse_vector: Vector2 = get_global_mouse_position() - global_position
	match ability_used:
		0:
			#var bullet_instance:RigidBody2D = bullet.instantiate()
			
			#bullet_instance.position = self.global_position + to_mouse_vector.normalized() * 50
			#bullet_instance.look_at(bullet_instance.position + to_mouse_vector.normalized())
			#get_node("/root/Node2D").add_child(bullet_instance)
			spawn_bullet(
				350,
				self.global_position + to_mouse_vector.normalized() * 50,
				to_mouse_vector.normalized())
		1:
			print("ability 1 used")
			
			for i in range(arrow_rain_count):
				var angle = randf_range(0,360)
				var distance = randf_range(0, arrow_rain_radius)
				#var bullet_instance: RigidBody2D = bullet.instantiate()
				#bullet_instance.position = get_global_mouse_position() + Vector2(distance,0).rotated(angle) + Vector2(0,-arrow_rain_height)
				#bullet_instance.look_at(bullet_instance.position + Vector2.DOWN)
				#get_node("/root/Node2D").add_child(bullet_instance)
				#bullet_instance.life_span = arrow_rain_height
				spawn_bullet(
					50,
					get_global_mouse_position() + Vector2(distance,0).rotated(angle) + Vector2(0,-arrow_rain_height),
					Vector2.DOWN,
					arrow_rain_height)
			
			change_ability(0)

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
