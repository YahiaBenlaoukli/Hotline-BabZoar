extends CharacterBody2D
class_name Player
signal lock_on_request

const SPEED = 500

var input : Vector2
var current_target: CharacterBody2D = null


@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var health = $Health
@onready var weapon : Weapon = $Weapon
@onready var team = $Team
@onready var cursor = $Cursor

func _ready():
	weapon.initialize(team.team)
	cursor.initialize(self,team.team)

func get_input():
	input.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	return input.normalized()

func _physics_process(delta):
	var player_input = get_input()
	
	velocity = player_input * SPEED
	
	if (velocity.length() == 0):
		animation_player.play("Holding_one_hand")
	else:
		animation_player.play("Walking_one_hand")
		
	
	
	move_and_slide()
	
	# Adjust the target angle
	var target_angle: float
	if current_target and is_instance_valid(current_target):
		target_angle = (current_target.global_position - global_position).angle()
	else:
		target_angle = (get_global_mouse_position() - global_position).angle()
	
	rotation = lerp_angle(rotation, target_angle, 0.5)


func _unhandled_input(event):
	if event.is_action_pressed("Shoot"):
		var target_pos: Vector2
		if current_target and is_instance_valid(current_target):
			target_pos = current_target.global_position
		else:
			target_pos = get_global_mouse_position()
		weapon.shoot(target_pos)
	if event.is_action_released("Reload"):
		reload()
	if event.is_action_pressed("Lock_on"):
		emit_signal("lock_on_request")

func reload():
	weapon.reload()
func get_team() -> int:
	return team.team

func handle_hit():
		if health.health <= 0:
			queue_free()
			
