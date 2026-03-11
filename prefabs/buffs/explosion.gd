extends Area2D

var strength = 900

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("explode")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.get_hit(strength)
	pass # Replace with function body.



func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
	pass # Replace with function body.
