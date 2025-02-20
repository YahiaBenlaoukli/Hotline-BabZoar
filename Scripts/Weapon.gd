extends Node2D
class_name Weapon

signal out_of_ammo

@onready var attack_cooldown = $AttackCooldown
@onready var animation_player = $AnimationPlayer

var Bullet_scene = preload("res://Scenes/bullet.tscn")
var team : int = -1

var max_ammo :int = 10
var current_ammo : int = max_ammo

func shoot(target_position: Vector2):
	if current_ammo > 0 and attack_cooldown.is_stopped() and Bullet_scene != null:
		var Bullet = Bullet_scene.instantiate()
		
		Bullet.dir = (target_position - global_position).normalized()
		
		Bullet.team = team
		Bullet.global_position = global_position 
		Bullet.rotation = Bullet.dir.angle()
		get_tree().current_scene.add_child(Bullet)
		attack_cooldown.start()
		animation_player.play("Shoot")
		current_ammo -= 1
		if current_ammo == 0:
			emit_signal("out_of_ammo")
		
func initialize(weapon_team: int):
	self.team = weapon_team

func reload():
	animation_player.play("Reload")
func stop_reload():
	current_ammo = max_ammo
