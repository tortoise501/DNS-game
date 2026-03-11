extends Node2D

var speed = 300
var velocity_vector = Vector2.ZERO

var maxHP = 1000.0
var currentHP = 1000.0
var alive = true

signal game_over

@onready var animation_handler = $AnimatedSprite2D
var shooting = false

var dashing = false
var dash_distance = 0
var dash_dir = Vector2.ZERO
var dash_start = Vector2.ZERO
var dash_acc_error = 10
var dash_speed = 5
@onready var dash_anim_pref = preload("res://prefabs/dash/dash_anim.tscn")


@onready var collision = $CollisionShape2D

var speed_buff_end_time = 0
var speed_buff_strength = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_hp_bar()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !alive:
		return
	
	if abs(global_position.x) > 1300 || abs(global_position.y) > 1300:
		get_hit(500 * delta)
	
	var modified_speed = speed
	if speed_buff_end_time > Time.get_ticks_msec():
		modified_speed += speed_buff_strength
	velocity_vector = Vector2.ZERO
	if dashing:
		collision.set_deferred("disabled",true)
		translate(dash_dir * dash_distance * delta * dash_speed)
		if (global_position - (dash_start + dash_dir * dash_distance)).length() < dash_acc_error:
			collision.set_deferred("disabled",false)
			dashing = false
	else:
		if Input.is_action_pressed("ui_up") || Input.is_key_pressed(KEY_W):
			velocity_vector += Vector2.UP
		if Input.is_action_pressed("ui_down") || Input.is_key_pressed(KEY_S):
			velocity_vector += Vector2.DOWN
		if Input.is_action_pressed("ui_left") || Input.is_key_pressed(KEY_A):
			velocity_vector += Vector2.LEFT
		if Input.is_action_pressed("ui_right") || Input.is_key_pressed(KEY_D):
			velocity_vector += Vector2.RIGHT
		translate(velocity_vector.normalized() * modified_speed * delta)
	if !shooting:
		if velocity_vector == Vector2.ZERO:
			animation_handler.play("idle")
		else:
			animation_handler.play("run")
		if velocity_vector.x > 0:
			animation_handler.flip_h = false
		elif velocity_vector.x < 0:
			animation_handler.flip_h = true
	else:
		if get_global_mouse_position().x < global_position.x:
			animation_handler.flip_h = true
		else:
			animation_handler.flip_h = false



func get_hit(damage):
	if dashing:
		return
	currentHP -= damage
	if currentHP <= 0:
		emit_signal("game_over")
		alive = false
		animation_handler.play("death")
	else:
		update_hp_bar()

func update_hp_bar():
	$CanvasLayer/Control/HPBarDecoration/ProgressBar.value = currentHP / maxHP * 100.0


func _on_weapon_shot(_variant: int) -> void:
	animation_handler.play("shoot")
	shooting = true
	pass # Replace with function body.



func _on_animated_sprite_2d_animation_finished() -> void:
	if shooting == true:
		shooting = false
	pass # Replace with function body.


func dash(dash_damage, dash_power, dash_to):
	var dash_anim_inst:Node2D = dash_anim_pref.instantiate()
	var dir = (dash_to - global_position).normalized()
	dash_anim_inst.global_position = (global_position + (global_position + dir * dash_power))/2.0
	dash_anim_inst.look_at(dash_anim_inst.global_position + dir)
	dash_anim_inst.dash_size = dash_power
	dash_anim_inst.dash_damage = dash_damage
	get_node("/root/Node2D").add_child(dash_anim_inst)
	dash_distance = dash_power
	dash_dir = dir
	dashing = true
	dash_start = global_position

func heal(strength):
	currentHP += strength
	if currentHP > maxHP:
		currentHP = maxHP
	update_hp_bar()

func speed_buff(strength, duration):
	speed_buff_end_time = Time.get_ticks_msec() + duration
	speed_buff_strength = strength
	pass
