extends Area2D

const SPEED = 2000
var dir : Vector2
var team : int = -1

func _physics_process(delta):
	position += SPEED * dir * delta


func _on_kill_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body.has_method("handle_hit"):
		if body.has_method("get_team") and body.get_team() != team :
			body.handle_hit()
		queue_free()
