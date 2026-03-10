extends Node2D

var speed = 300

var maxHP = 1000
var currentHP = 1000


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
		pass

func get_hit(damage):
	currentHP -= damage
	print("current HP: %d" % currentHP)
	if currentHP <= 0:
		print("player is dead")
