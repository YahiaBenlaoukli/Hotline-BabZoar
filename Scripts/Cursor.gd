extends Area2D

@export var player: Node2D  # Assign the player node in the Inspector
@export var min_distance: float = 100.0  # Minimum distance from the player

func _ready():
	visible = true
	player = get_parent().get_node("Player")

func _process(delta):
	if player:
		var mouse_pos = get_global_mouse_position()
		var offset = mouse_pos - player.global_position
		var distance = offset.length()

		if distance < min_distance:
			global_position = player.global_position + offset.normalized() * min_distance
		else:
			global_position = mouse_pos  # Allow free movement if outside the restricted radius
