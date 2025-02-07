extends CharacterBody2D
class_name Player

const SPEED = 500

var input : Vector2
@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var health = $Health
@onready var weapon = $Weapon


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
	var target_angle = (get_global_mouse_position() - global_position).angle()
	
	rotation = lerp_angle(rotation, target_angle, 0.5)

func _unhandled_input(event):
	if event.is_action_pressed("Shoot"):
		weapon.shoot(get_global_mouse_position())  # Pass mouse position as target


func handle_hit():

	if health.health <= 0:
		queue_free()
