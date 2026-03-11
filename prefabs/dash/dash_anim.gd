extends Node2D

var dash_size = 100
var dash_damage = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(dash_size)
	var curr_size = $CollisionShape2D.shape.size.x
	var mult = dash_size / curr_size
	scale *= mult
	print(mult)
	$AnimatedSprite2D.play("default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.get_hit(dash_damage)
