extends Node2D

signal state_changed(new_state)

const SPEED = 50
const MIN_PATROL_DISTANCE = 100
const MAX_PATROL_DISTANCE = 150

enum State {
	PATROL,
	ENGAGE
}

@onready var player_detection_zone = $PlayerDetectionZone
@onready var patrol_timer = $PatrolTimer
@onready var animation_player = $"../AnimationPlayer"

var target: CharacterBody2D = null
var weapon: Weapon = null
var actor = null
var team : int = -1

# Patrol state
var origin: Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached = true

var current_state = -1 : set = set_state

func _ready():
	set_state(State.PATROL)

func _physics_process(delta):
	match current_state:
		State.PATROL:
			if not patrol_location_reached:
				animation_player.play("Walking")
				var direction = actor.global_position.direction_to(patrol_location)
				actor.velocity = direction * SPEED
				actor.rotate_toward(patrol_location)
				actor.move_and_slide()
				
				if actor.global_position.distance_to(patrol_location) < 5:
					animation_player.play("Idle")
					patrol_location_reached = true
					actor.velocity = Vector2.ZERO
					patrol_timer.start()
		State.ENGAGE:
			if target != null and weapon != null:
				animation_player.play("Idle")
				actor.velocity = lerp(actor.velocity / 2,Vector2.ZERO,0.1)
				var angle_to_target = (target.global_position - actor.global_position).angle()
				actor.rotate_toward(target.global_position)
				if abs(actor.rotation - angle_to_target) < 0.1:
					weapon.shoot(target.global_position)
			else:
				print("In engage state but player or weapon is missing.")
		_:
			print("Error: State doesn't exist.")

func set_state(new_state: State):
	if new_state == current_state:
		return
	
	# Handle exiting current state
	if current_state == State.ENGAGE:
		patrol_timer.stop()
	
	# Handle entering new state
	match new_state:
		State.PATROL:
			origin = global_position
			patrol_timer.start()
			patrol_location_reached = true
		State.ENGAGE:
			patrol_timer.stop()
	
	current_state = new_state
	emit_signal("state_changed", current_state)

func initialize(actor_node : CharacterBody2D, weapon_node: Weapon,team : int):
	self.actor = actor_node
	self.weapon = weapon_node
	self.team = team
	weapon.out_of_ammo.connect(handle_reload)

func handle_reload():
	weapon.reload()

func _on_patrol_timer_timeout():
	var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var distance = randf_range(MIN_PATROL_DISTANCE, MAX_PATROL_DISTANCE)
	patrol_location = origin + direction * distance
	patrol_location_reached = false


func _on_detection_zone_body_entered(body):
	if body.has_method("get_team") and body.get_team() != team:
		set_state(State.ENGAGE)
		target = body


func _on_detection_zone_body_exited(body):
	if target and body == target:
		set_state(State.PATROL)
		target = null
