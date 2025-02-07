extends CharacterBody2D

@onready var health = $Health
@onready var ai = $Ai
@onready var weapon = $Weapon

func _ready():
	ai.initialize(self,weapon)

func shoot_at_target(target: CharacterBody2D):
	if target:
		weapon.shoot(target.global_position)  # Pass player's position as target
		

func handle_hit():
	health.health -= 20
	if health.health <= 0:
		queue_free()

