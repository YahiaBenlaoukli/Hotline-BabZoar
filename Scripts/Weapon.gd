extends Node2D
class_name Weapon

@onready var attack_cooldown = $AttackCooldown
@onready var animation_player = $AnimationPlayer

var Bullet_scene = preload("res://Scenes/bullet.tscn")

func shoot(target_position: Vector2):
	if attack_cooldown.is_stopped() and Bullet_scene != null:
		var Bullet = Bullet_scene.instantiate()
		
		# Set the direction towards the target instead of mouse position
		Bullet.dir = (target_position - global_position).normalized()
		
		Bullet.global_position = global_position 
		Bullet.rotation = Bullet.dir.angle()
		get_tree().current_scene.add_child(Bullet)
		attack_cooldown.start()
		animation_player.play("Shoot")
