extends Node2D


@export var health: int = 100 : set = set_health

func set_health(new_health : int):
	health = clamp(new_health,0,1000)
