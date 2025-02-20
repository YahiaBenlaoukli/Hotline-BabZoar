extends Area2D

@export var min_distance: float = 100.0
@onready var sprite_2d = $Sprite2D

var Player_node : CharacterBody2D
var enemy_locked : CharacterBody2D
var team : int = -1
var looking_at_mouse = true

func _ready():
	visible = true
	top_level = true

func _process(delta):
	if Player_node:
		if looking_at_mouse:
			var mouse_pos = get_global_mouse_position()
			var offset = mouse_pos - Player_node.global_position
			var distance = offset.length()

			if distance < min_distance:
				global_position = Player_node.global_position + offset.normalized() * min_distance
			else:
				global_position = mouse_pos
		else:
			if enemy_locked and is_instance_valid(enemy_locked):
				global_position = enemy_locked.global_position
			else:
				enemy_locked = null
				looking_at_mouse = true

func initialize(Player_node : CharacterBody2D, team : int):
	self.Player_node = Player_node
	self.team = team
	Player_node.lock_on_request.connect(fixed_cursor)

func fixed_cursor():
	if looking_at_mouse:
		# Find all enemies in the cursor's area
		var enemies_in_range = []
		for body in get_overlapping_bodies():
			if body.is_in_group("enemies") and body.get_team() != team and is_instance_valid(body):
				enemies_in_range.append(body)
		
		if enemies_in_range.size() > 0:
			# Select the closest enemy to the cursor's current position
			var closest_enemy = null
			var closest_distance = INF
			for enemy in enemies_in_range:
				var dist = global_position.distance_to(enemy.global_position)
				if dist < closest_distance:
					closest_distance = dist
					closest_enemy = enemy
			enemy_locked = closest_enemy
			looking_at_mouse = false
			if Player_node:
				Player_node.current_target = closest_enemy
	else:
		# Release the lock
		enemy_locked = null
		looking_at_mouse = true
		if Player_node:
			Player_node.current_target = null
