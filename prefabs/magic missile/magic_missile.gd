extends Area2D

var speed = 400
var life_span = 1000
var damage = 100
var initia_pos: Vector2
var active = true
@onready var animation_handler = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initia_pos = global_position	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if active:
		animation_handler.play("default")
		translate(Vector2.RIGHT.rotated(rotation) * speed * delta)
		if (global_position - initia_pos).length() > life_span:
			explode()

func explode():
	animation_handler.play("explode")
	active = false
	pass


func _on_animated_sprite_2d_animation_finished() -> void:
	if !active:
		queue_free()



func _on_body_entered(body: Node2D) -> void:
	if active && body.is_in_group("Player") && body.has_method("get_hit"):
		body.get_hit(damage)
		explode()
	if active && body.is_in_group("PlayerBullet"):
		look_at(global_position + Vector2.RIGHT)
		explode()
