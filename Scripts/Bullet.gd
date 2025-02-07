extends Area2D

const SPEED = 2000
var dir : Vector2

func _physics_process(delta):
	position += SPEED * dir * delta


func _on_kill_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body.has_method("handle_hit"):
		body.handle_hit()
		queue_free()
