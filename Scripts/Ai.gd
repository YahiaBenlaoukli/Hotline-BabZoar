extends Node2D

signal state_changed(new_state)

enum state{
	PATROL,
	ENGAGE
}
@onready var player_detection_zone = $PlayerDetectionZone

var player : Player = null
var weapon : Weapon = null
var actor = null

var current_state = state.PATROL : set = set_state
func _process(delta):
	match current_state:
		state.PATROL:
			pass
		state.ENGAGE:
			if player != null and weapon != null:
				var angle_to_player =(player.global_position - actor.global_position).angle()
				actor.rotation = lerp(actor.rotation,angle_to_player,0.1)
				if abs(actor.rotation - angle_to_player) <0.1:
					weapon.shoot(player.global_position)
			else:
				print("in engage state")
		_:
			print("error state doesnt exist")
		
func set_state(new_state : int):
	if new_state == current_state:
		pass
	else:
		current_state = new_state
		emit_signal("state_changed",current_state)
		

func initialize(actor,weapon : Weapon):
	self.actor = actor
	self.weapon = weapon

func get_new_direction():
	pass

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		set_state(state.ENGAGE)
		player = body
