extends CharacterBody2D

@onready var health = $Health
@onready var ai = $Ai
@onready var weapon : Weapon = $Weapon
@onready var team = $Team

func _ready():
	ai.initialize(self,weapon,team.team)
	weapon.initialize(team.team)
	

func shoot_at_target(target: CharacterBody2D):
	if target:
		weapon.shoot(target.global_position)  # Pass player's position as target
		
		
func get_team() -> int:
	return team.team

func _process(delta):
	move_and_slide()
func handle_hit():
		health.health -= 20
		if health.health <= 0:
			queue_free()
func rotate_toward(location : Vector2):
	rotation = lerp(rotation,global_position.direction_to(location).angle(),0.1)
