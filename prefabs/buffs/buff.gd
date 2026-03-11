extends Area2D

enum BuffType {HEAL, SPEED, BOMB, COIN}

@export var buff_type := BuffType.HEAL

var strength = 100
var duration = 5000
var radius = 300


func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		match buff_type:
			BuffType.HEAL:
				body.heal(strength)
				drink()
			BuffType.COIN:
				get_node("/root/Node2D").pick_up_coin(strength)
				drink()
			BuffType.SPEED:
				body.speed_buff(strength, duration)
				drink()
	if body.is_in_group("PlayerBullet"):
		match buff_type:
			BuffType.BOMB:
				get_node("/root/Node2D").explode(strength * 9,radius,global_position)
				drink()

func drink():
	queue_free()
