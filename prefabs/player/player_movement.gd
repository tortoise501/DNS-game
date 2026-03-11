extends Node2D

var speed = 300

var maxHP = 1000
var currentHP = 1000

@onready var animation_handler = $AnimatedSprite2D
var shooting = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_hp_label()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	var velocity_vector = Vector2.ZERO
	if Input.is_action_pressed("ui_up") || Input.is_key_pressed(KEY_W):
		velocity_vector += Vector2.UP
	if Input.is_action_pressed("ui_down") || Input.is_key_pressed(KEY_S):
		velocity_vector += Vector2.DOWN
	if Input.is_action_pressed("ui_left") || Input.is_key_pressed(KEY_A):
		velocity_vector += Vector2.LEFT
	if Input.is_action_pressed("ui_right") || Input.is_key_pressed(KEY_D):
		velocity_vector += Vector2.RIGHT
	translate(velocity_vector.normalized() * speed * delta)
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
	currentHP -= damage
	print("current HP: %d" % currentHP)
	update_hp_label()
	if currentHP <= 0:
		$HPLabel.text = "dead"
		print("player is dead")

func update_hp_label():
	$HPLabel.text = "%d/%d" % [currentHP, maxHP]


func _on_weapon_shot(int: Variant) -> void:
	animation_handler.play("shoot")
	shooting = true
	pass # Replace with function body.



func _on_animated_sprite_2d_animation_finished() -> void:
	if shooting == true:
		shooting = false
	pass # Replace with function body.
