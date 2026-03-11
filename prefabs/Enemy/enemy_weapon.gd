extends Node2D

@onready var melee_attack_pref = preload("res://prefabs/enemy_attack/attack.tscn")
@onready var magic_missile_pref = preload("res://prefabs/magic missile/magic_missile.tscn")
const Attack_type = preload("res://prefabs/common/attack_type.gd").Attack_type
var attack_type = Attack_type.MELEE
@export var offset := 40 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func attack(player_pos:Vector2):
	match attack_type:
		Attack_type.MELEE:
			var attack_inst = melee_attack_pref.instantiate()
			attack_inst.damage = get_parent().attack_damage
			attack_inst.global_position = (global_position + player_pos)/2
			attack_inst.look_at(player_pos)
			get_node("/root/Node2D").add_child(attack_inst)
		Attack_type.MAGIC_MISSILE:
			var attack_inst = magic_missile_pref.instantiate()
			attack_inst.damage = get_parent().attack_damage
			attack_inst.global_position = global_position + (player_pos - global_position).normalized() * offset
			attack_inst.look_at(player_pos)
			get_node("/root/Node2D").add_child(attack_inst)
	pass
