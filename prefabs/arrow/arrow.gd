extends RigidBody2D

var speed = 800
var life_span = 1000
var min_speed = 200
var initial_pos = Vector2.ZERO

var damage = 350

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 1
	#linear_velocity = (get_global_mouse_position() - global_position).normalized() * speed
	linear_velocity = Vector2.from_angle(rotation) * speed
	initial_pos = global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#global_rotation = linear_velocity.
	#look_at(global_position + linear_velocity)
	if (global_position - initial_pos).length() > life_span:
		break_arrow()
	if linear_velocity.length() < min_speed:
		break_arrow()
	pass
	
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Enemy") && body.has_method("get_hit"):
		body.get_hit(damage)
		damage = 0
		break_arrow()
	pass # Replace with function body.


func break_arrow():
	linear_velocity *= 0
	angular_velocity *= 0
	#play break animation
	queue_free()
	
