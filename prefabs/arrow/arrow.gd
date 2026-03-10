extends RigidBody2D

var speed = 800

var life_span = 1000

var initial_pos = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#linear_velocity = (get_global_mouse_position() - global_position).normalized() * speed
	linear_velocity = Vector2.from_angle(rotation) * speed
	initial_pos = global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#global_rotation = linear_velocity.
	look_at(global_position + linear_velocity)
	if (global_position - initial_pos).length() > life_span:
		queue_free()
	pass
