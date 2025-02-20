extends Camera2D

@export var player: Node2D
@export var smooth_speed: float = 5.0

func _process(delta):
	if player:
		position = position.lerp(player.position, smooth_speed * delta)
