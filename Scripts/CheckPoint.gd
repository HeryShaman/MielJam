extends Area2D

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.last_checkpoint_position = body.global_position
		print("Collision")
